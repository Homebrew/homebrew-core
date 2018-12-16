class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.8.1.tar.gz"
  sha256 "292c84265ab33a0a0cbb063d0049ac8bd78cb0309cb207c3e575ca4a6ee13659"

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
