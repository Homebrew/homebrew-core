class CmuSphinxbase < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "https://cmusphinx.sourceforge.io/"
  license "BSD-2-Clause"

  stable do
    url "https://downloads.sourceforge.net/project/cmusphinx/sphinxbase/0.8/sphinxbase-0.8.tar.gz"
    sha256 "55708944872bab1015b8ae07b379bf463764f469163a8fd114cbb16c5e486ca8"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/sphinxbase[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "10c702ad300d51ffac6ed0251cf3b64952d549ad0a67792b80fe055a182014f2"
    sha256 cellar: :any,                 arm64_big_sur:  "d8ca2666d2ee6c5ff4a5a88ad086cfcf3e0cf744e6614ea31b451dfd86196c17"
    sha256 cellar: :any,                 monterey:       "36b168f91bef9ea210c0fcbe6ace6a24d14aa50d11fd464a742e543ede25a6fe"
    sha256 cellar: :any,                 big_sur:        "774670d79572ac633b5acf646a15ca54055e140044476bfeac7bc1d377a1dbe4"
    sha256 cellar: :any,                 catalina:       "0cea9513b180773ff3c45d24453e962ef4ad5d1f923c4c22716437f3580b195f"
    sha256 cellar: :any,                 mojave:         "b55c9f16e8b89fc515d9bf8bd6ed91f532d0c82a46be01cd9792bb27076a6a51"
    sha256 cellar: :any,                 high_sierra:    "2ebde8d649a3e78c3e219c83e1f12e6cee924f5404b0d68e8fe7d220c8dad0f5"
    sha256 cellar: :any,                 sierra:         "fde603304716876e192bef822f8df21c26e09688d43580d3f9a61c78e03dbbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "078ae69b46fd06a8fcd68df8457e8c96e078c0276a027ae640ac18aad99d6669"
  end

  head do
    url "https://github.com/cmusphinx/sphinxbase.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "swig" => :build
  end

  depends_on "pkg-config" => :build
  # If these are found, they will be linked against and there is no configure
  # switch to turn them off.
  depends_on "libsamplerate"
  depends_on "libsndfile"

  uses_from_macos "bison" => :build

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "cmd_ln.h"

      int main(int argc, char **argv) {
        cmd_ln_t *config = NULL;

        config = cmd_ln_init(NULL, NULL, TRUE,
          "-hello", "world", NULL);
        cmd_ln_free_r(config);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lsphinxbase", "-I#{include}/sphinxbase", "-o", "test"
    system "./test"
  end
end
