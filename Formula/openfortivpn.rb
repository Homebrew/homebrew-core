class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.8.1.tar.gz"
  sha256 "292c84265ab33a0a0cbb063d0049ac8bd78cb0309cb207c3e575ca4a6ee13659"

  bottle do
    sha256 "f90028421a138d158dbc999c801612c18439692f350a07f4212a2e52d7e2f0fd" => :mojave
    sha256 "45dfd4656767ecb047f26f26dea898dc223a8bdd57e9e747194ef519db124358" => :high_sierra
    sha256 "11c168aa5e680d933295cf0454787bcfc359c56ec474ee812a756032e0b7723d" => :sierra
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
