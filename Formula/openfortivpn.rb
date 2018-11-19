class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.8.0.tar.gz"
  sha256 "b64e99c56b402b5f026802de1cbf5fe0a12de6654da6b1675e1cadd7721e7701"

  bottle do
    sha256 "5661591674a75b63cf60c62c7de9c697640853035098e57a40f3c2e73346f588" => :mojave
    sha256 "59573b07afe494585cb9b91fd3f4705eb82f308357385ab039c24cfa21058e9e" => :high_sierra
    sha256 "d36149e64474ab7b964011b0a8d3c78b2fa62c4592ed4508c944e911862f57d9" => :sierra
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
