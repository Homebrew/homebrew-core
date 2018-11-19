class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.8.0.tar.gz"
  sha256 "b64e99c56b402b5f026802de1cbf5fe0a12de6654da6b1675e1cadd7721e7701"

  bottle do
    sha256 "b93d5ae9750885cebc64e0fd39e99b392c112c2aced29d0b33e4d86ddffd935a" => :mojave
    sha256 "e50554d89dabf795108f02695a2ebe05554ee3164c692ef1ecdd6fa8fdd0e37d" => :high_sierra
    sha256 "41d9bdc5b78eff99fe35ef78d635fed91e76fe1e6a5d5d894339a025f634f44a" => :sierra
    sha256 "53e0106ebd966a5eb3dc3547add6c182f3d5c2322d38a6ef91d6617fc9e3a07a" => :el_capitan
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
