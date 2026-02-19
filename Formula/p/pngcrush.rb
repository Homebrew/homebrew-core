class Pngcrush < Formula
  desc "Optimizer for PNG files"
  homepage "https://pmt.sourceforge.io/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.8.13/pngcrush-1.8.13-nolib.tar.xz"
  sha256 "3b4eac8c5c69fe0894ad63534acedf6375b420f7038f7fc003346dd352618350"
  # The license is similar to "Zlib" license with clauses phrased like
  # the "Libpng" license section for libpng version 0.5 through 0.88.
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/pngcrush[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "d480e8fcafb2cce34d273a2142d1db3513fb094e2e1c6b638b67d2114b75a91f"
    sha256 cellar: :any,                 arm64_sequoia: "86ee7fe3bb318dd870dfa82ed5e765ef2852723c2dc0a2406cbaf131779bc0fe"
    sha256 cellar: :any,                 arm64_sonoma:  "e98af00364a8cae0050e46f60c6b7ae0213d43fff7ae59616aacee39e33931b0"
    sha256 cellar: :any,                 sonoma:        "9e118f22662c43c9d1520be4b73645146939660c600e428aa540df8261ea1843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2c169a69b99d3ca7c13d4b8779adfd09568b8b9059c0d510e66008905513f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68503c123cc4886ca3b1e759a7b29e9c9e7abed51d31f78f37f197c4bf66affd"
  end

  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Use Debian's patch to fix build with `libpng`.
  # Issue ref: https://sourceforge.net/p/pmt/bugs/82/
  patch do
    url "https://sources.debian.org/data/main/p/pngcrush/1.8.13-1/debian/patches/ignore_PNG_IGNORE_ADLER32.patch"
    sha256 "d1794d1ffef25a1c974caa219d7e33c0aa94f98c572170ec12285298d0216c29"
  end

  def install
    zlib = OS.mac? ? "#{MacOS.sdk_path_if_needed}/usr" : Formula["zlib-ng-compat"].opt_prefix
    args = %W[
      CC=#{ENV.cc}
      LD=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      PNGINC=#{Formula["libpng"].opt_include}
      PNGLIB=#{Formula["libpng"].opt_lib}
      ZINC=#{zlib}/include
      ZLIB=#{zlib}/lib
    ]
    system "make", *args
    bin.install "pngcrush"
  end

  test do
    system bin/"pngcrush", test_fixtures("test.png"), File::NULL
  end
end
