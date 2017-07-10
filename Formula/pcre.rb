class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "http://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.41.tar.bz2"
  sha256 "e62c7eac5ae7c0e7286db61ff82912e1c0b7a0c13706616e94a7dd729321b530"

  bottle do
    cellar :any
    sha256 "61893a4a65d393f1b4447b79550569b341ba61b49e36900a35f59207bba11923" => :sierra
    sha256 "4a4490b3cab2c7eaf6a23a41a0060c2c6e9e818cfaaf51830f9b3a5ec525d1e6" => :el_capitan
    sha256 "2d65bfe7d3ced1fc4e4d5649650a47b35c2b2e6b5eda8bf968b50e57ce4ee8f5" => :yosemite
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
