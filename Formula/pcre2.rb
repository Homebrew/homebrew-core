class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre2-10.31.tar.bz2"
  sha256 "e07d538704aa65e477b6a392b32ff9fc5edf75ab9a40ddfc876186c4ff4d68ac"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    sha256 "be84360b53e44a8653017212119b9467f7e2b843f3bf378c4c7023b0bda78144" => :high_sierra
    sha256 "f372836d1dfc6ed0fb0e7d1344a0c9cbd5a77968722be997bc1defce659781ac" => :sierra
    sha256 "764e01a0580da89ce906e1ad1441841455b9dab11339d1add2108c3e9b6382a2" => :el_capitan
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
