class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre/8.39/pcre-8.39.tar.bz2"
  sha256 "b858099f82483031ee02092711689e7245586ada49e534a06e678b8ea9549e8b"

  bottle do
    cellar :any
    sha256 "a9333dda2e7b2f2a3f0de5e542d24f4cd0750edc53bfaa6bbf34f0d03db5fb3c" => :el_capitan
    sha256 "202f05c7d2dc78c30ef7115395ec0bf7bc3f40bfb2dd1704ca1a01ff1661142c" => :yosemite
    sha256 "d2bb8776d8dca524aa1cbbb4f18b156658d673fe5424daeb96100b01b55805dd" => :mavericks
  end

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  fails_with :llvm do
    build 2326
    cause "Bus error in ld on SL 10.6.4"
  end

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8",
                          "--enable-pcre8",
                          "--enable-pcre16",
                          "--enable-pcre32",
                          "--enable-unicode-properties",
                          "--enable-pcregrep-libz",
                          "--enable-pcregrep-libbz2",
                          "--enable-jit"
    system "make"
    ENV.deparallelize
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/pcregrep", "regular expression", "#{prefix}/README"
  end
end
