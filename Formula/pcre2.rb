class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre2-10.35.tar.bz2"
  sha256 "9ccba8e02b0ce78046cdfb52e5c177f0f445e421059e43becca4359c669d4613"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    sha256 "af3bf030a455daf0a560f8d9e433f7a803d7150933895699f311d661c33b9729" => :catalina
    sha256 "9bc0815c6c4c584ef16e93e5ecf37aa786303d88f9321274a29b4f60876d583f" => :mojave
    sha256 "494acfae91394df3c48b2bdb13d46b5a540e401c54be9f7c10234e6001fba678" => :high_sierra
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
