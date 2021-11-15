class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "https://www.pcre.org/"
  license "BSD-3-Clause"

  stable do
    url "https://ftp.pcre.org/pub/pcre/pcre-8.45.tar.bz2"
    mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.45.tar.bz2"
    sha256 "4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://ftp.pcre.org/pub/pcre/"
    regex(/href=.*?pcre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "11193fd0a113c0bb330b1c2c21ab6f40d225c1893a451bba85e8a1562b914a1c"
    sha256 cellar: :any,                 arm64_big_sur:  "2d6bfcafce9da9739e32ee433087e69a78cda3f18291350953e6ad260fefc50b"
    sha256 cellar: :any,                 monterey:       "5e5cc7a5bf8bb6488ec57d4263bf6b0bc89e93252a0a2460f846de29373162d8"
    sha256 cellar: :any,                 big_sur:        "fb2fefbe1232706a603a6b385fc37253e5aafaf3536cb68b828ad1940b95e601"
    sha256 cellar: :any,                 catalina:       "180d88dc2230e98162685b86d00436903db4349aac701f9769997d61adb78418"
    sha256 cellar: :any,                 mojave:         "a42b79956773d18c4ac337868cfc15fadadf5e779d65c12ffd6f8fd379b5514c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296026b6d5430399e40fb4f8074045a9a27d5374d83f2f6d4659c2647959f36d"
  end

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-pcre8
      --enable-pcre16
      --enable-pcre32
      --enable-unicode-properties
      --enable-pcregrep-libz
      --enable-pcregrep-libbz2
    ]

    # JIT not currently supported for Apple Silicon or OS older than sierra
    args << "--enable-jit" if MacOS.version >= :sierra && !Hardware::CPU.arm?

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/pcregrep", "regular expression", "#{prefix}/README"
  end
end
