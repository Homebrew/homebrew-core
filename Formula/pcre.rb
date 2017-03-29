class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.40.tar.bz2"
  sha256 "00e27a29ead4267e3de8111fcaa59b132d0533cdfdbdddf4b0604279acbcf4f4"

  bottle do
    cellar :any
    sha256 "0c6b0b755f8bb88f277ffca1bad6554c995936e42d32453addde97da58b72b31" => :sierra
    sha256 "f4851122510374c12e411ac2fad63ce8bd3c1590b6e152df64ad5b37b20cf200" => :el_capitan
    sha256 "6c69cca320bc1db83345100f0f8ff181cf16024d5842ac970f8d1f1cdc24e05d" => :yosemite
  end

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
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
