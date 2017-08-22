class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.0.3.tar.lz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.0.3.tar.lz"
  sha256 "b52fd3bc9693de16db93aa23a11a56f3cdb3fbf005a360145401ab5d252490f5"

  head do
    url "https://gitlab.com/libidn/libidn2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gettext" => :build
    depends_on "gengetopt" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libunistring"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn2", "räksmörgås.se", "blåbærgrød.no"
  end
end
