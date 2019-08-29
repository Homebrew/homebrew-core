class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.10.0.tar.gz"
  sha256 "d6ea0c84c0cf811530073fa19865334bb42ab10a780157fe95c4efb3476ad58d"
  revision 1

  bottle do
    sha256 "30d87b41db1047d53b87f9fe79f706516426bf52f34e6af0f602dc69ebeb05ad" => :mojave
    sha256 "52a83eaaeea9aa0bdf52d72f9976207ac6c18088c3cb60765e1567f8b2bff4ee" => :high_sierra
    sha256 "878207725419186bfcf93ec05c8bc7348e4e68b65a6f92ef29a8245879aa0c0f" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
