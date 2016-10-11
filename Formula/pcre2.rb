class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.22.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre2/10.21/pcre2-10.22.tar.bz2"
  sha256 "b2b44619f4ac6c50ad74c2865fd56807571392496fae1c9ad7a70993d018f416"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    sha256 "45611d34aaec5ea8c7032fab040e63b18ecd8f1657519b9ce5ba397f3f2addaf" => :sierra
    sha256 "8acb48f5116ba5b97707b730c60d7d22840b27d6a4a434e28afb8985583db3f5" => :el_capitan
    sha256 "de109142c8edc8a357ede1cdbaceb7be924fc6da52b9a366ca9d214ddfa2ee9a" => :yosemite
    sha256 "64f26a62c8d94ced2b82d41d1dae3485d95639daaf8806aea9fb5f063d27690c" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
