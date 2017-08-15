class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "http://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre2-10.30.tar.bz2"
  sha256 "90bd41c605d30e3745771eb81928d779f158081a51b2f314bbcc1f73de5773db"

  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    sha256 "1ff0a7fa5c45bebb4c3ea138a5cea73a83a7663ed9bcf2636bb9177af6dee9e9" => :sierra
    sha256 "15b40ba0f293ebea4a0108db7436a301523bac14e16997d20acd778e94bb3545" => :el_capitan
    sha256 "0ec2d3f9b5e01424bf13a06a4e55894ed708eee2015fa43ce0755953c5afd885" => :yosemite
  end

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
