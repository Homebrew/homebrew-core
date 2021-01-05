class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.44.tar.bz2"
  sha256 "19108658b23b3ec5058edc9f66ac545ea19f9537234be1ec62b714c84399366d"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.pcre.org/pub/pcre/"
    regex(/href=.*?pcre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "a67dd6141e117f849bbb7d3bde92ffb6485921939c1d64e39a3f7fd0dac3f523" => :big_sur
    sha256 "e70ba0f6ae7f9ef638f4564d6b75b8d1e9db9f427057e9029e1686471e9174c6" => :arm64_big_sur
    sha256 "f8ac266e04f984fa55091a43f0fdc39a40d57c2489d289a186c88ccedaba7eeb" => :catalina
    sha256 "ed9b483538da7bc6559d2e63dd36659736fab9510681661d970d707a18731de4" => :mojave
    sha256 "aeea1351e1439847d00c3cee54bd28639493e686f809568cf42fea7bb28da2a5" => :high_sierra
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

    # JIT not currently supported for Apple Silicon
    args << "--enable-jit" unless Hardware::CPU.arm?

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
