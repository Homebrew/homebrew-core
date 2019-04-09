class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.9.0.tar.gz"
  sha256 "2087e9b6d785037d1eb0cf28c889612b7774dd3bf7652da15a43fc33068581d9"

  bottle do
    sha256 "5875f3c8a5099a1f452f8d6e6bbe387e2005c5874b7d10e735c75bb0fecde78e" => :mojave
    sha256 "b3dd47124399a997924fcce9509803ccbcf69dabb93181c7f378975214b76f1d" => :high_sierra
    sha256 "1fc3445fceb394dfa2d63a9036cc510d2f83e111ae82c1650c3ad5991e8497db" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    system bin/"openfortivpn", "--version"
  end
end
