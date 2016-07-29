class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "http://www.pcre.org/"

  head "svn://vcs.exim.org/pcre2/code/trunk"

  stable do
    url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.22.tar.bz2"
    mirror "https://www.mirrorservice.org/sites/downloads.sourceforge.net/p/pc/pcre/pcre2/10.21/pcre2-10.22.tar.bz2"
    sha256 "b2b44619f4ac6c50ad74c2865fd56807571392496fae1c9ad7a70993d018f416"
  end

  bottle do
    cellar :any
    sha256 "866b103f6047a6787c59a3db68cae15f527ca84879ce066a018ca58f3d7dbafe" => :el_capitan
    sha256 "c7dee4d41d2a6ab1cfb080d0a6d6989ec921f83c99ea287fba32d77d71903968" => :yosemite
    sha256 "96c2bf0c4e5b4fcd7c193e72fa5e1f7e2a08c102b98a68c614d4cb30d9ec9135" => :mavericks
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
    system "#{bin}/pcre2grep", "regular expression", "#{prefix}/README"
  end
end
