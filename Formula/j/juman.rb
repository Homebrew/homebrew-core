class Juman < Formula
  desc "Japanese morphological analysis system"
  homepage "https://nlp.ist.i.kyoto-u.ac.jp/index.php?JUMAN"
  license "BSD-3-Clause"

  stable do
    url "https://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-7.01.tar.bz2"
    sha256 "64bee311de19e6d9577d007bb55281e44299972637bd8a2a8bc2efbad2f917c6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "68ea21f6a0d59d8aaca739e79302615c6dee8dfc5f5f15f6e686a3df478e8372"
    sha256 arm64_sequoia:  "8db93b953c7cb1eac967bb6b7ef3cce0479f2ebecca298de87b92aa8e5324013"
    sha256 arm64_sonoma:   "0fe537854a305d8678893c6e15fea60516513470425844c61c33cd378892ca86"
    sha256 arm64_ventura:  "1b844be8a1ab2d3d1a10245fb3c887c9175a7836c86275ea67b3dfdd8e3abc7e"
    sha256 arm64_monterey: "cf0f825ad7796245c453f7993f4b7f5d069c4e4eb190ee5fcc46f86ad74f61b5"
    sha256 arm64_big_sur:  "9b0c1166c946ef258a558961fa82660502d705bbbecf6b8735a805b093802432"
    sha256 sonoma:         "d2a2aa1611d8028a63e9d2cd8d3eea9c9cf9b66e2e5ee05e4ff5e91b4a34ffa0"
    sha256 ventura:        "fea60e1ecb3168344e4d5576680b79b76036e6bf19d24553c5cde0c914ec8b1d"
    sha256 monterey:       "b8076e4c5626f942eff9a9e95ef8f06a9a2e013c344b626b2dc7c30756eb64aa"
    sha256 big_sur:        "69ca5acb9395c257b591bd6eedde58c0707929af25b767d470dcb5fef786c054"
    sha256 catalina:       "0cb4d99f79b907922d8352e841096301a132ab0f385c75910ab53198b1f72ab7"
    sha256 arm64_linux:    "e04f2b077fb8fbaa2064b621c875966f1c6f8424f5f9c7d6d4ab2cd162b484bd"
    sha256 x86_64_linux:   "dc72214b5b06cb06dee3a256586b433541d36d3c1af89282952dbdc5e1f232b4"
  end

  head do
    url "https://github.com/ku-nlp/juman.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "libnsl"
  end

  fails_with :gcc do
    cause "makemat/.libs/makemat: U00005f62U00005bb9U00008a5e  is undefined in  JUMAN.grammar ."
  end

  def install
    # Fix compile with newer Clang
    if DevelopmentTools.clang_build_version >= 1403 || ENV.compiler == :llvm_clang
      ENV.append_to_cflags "-Wno-implicit-int -Wno-implicit-function-declaration"
    end

    args = []
    if build.head?
      inreplace "configure.ac", /^AC_PROG_CC$/, "\\0\nAC_PROG_CPP"
      system "autoreconf", "--force", "--install", "--verbose"
      # Work around macOS case-insensitive filesystem causing errors for HEAD build
      if OS.mac?
        mv "VERSION", "VERSION.txt"
        inreplace ["Makefile.in", "juman/Makefile.in"], /\bVERSION\b/, "VERSION.txt"
      end
    elsif OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      # Help old config scripts identify arm64 linux
      args << "--build=aarch64-unknown-linux-gnu"
    end

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal <<~EXPECT, pipe_output(bin/"juman", "\xe4\xba\xac\xe9\x83\xbd\xe5\xa4\xa7\xe5\xad\xa6")
      京都 きょうと 京都 名詞 6 地名 4 * 0 * 0 "代表表記:京都/きょうと 地名:日本:府"
      @ 京都 きょうと 京都 名詞 6 地名 4 * 0 * 0 "代表表記:京都/きょうと 地名:日本:京都府:市"
      大学 だいがく 大学 名詞 6 普通名詞 1 * 0 * 0 "代表表記:大学/だいがく 組織名末尾 カテゴリ:場所-施設 ドメイン:教育・学習"
      EOS
    EXPECT
  end
end
