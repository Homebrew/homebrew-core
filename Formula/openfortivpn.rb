class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.14.1.tar.gz"
  sha256 "bc62fc6ecaaa6c6f8f2510e14a067a0cb9762158d9460c04555990bba44b50ca"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 "0c04566ef63f3cc1cb5062c3a18b78f6fed368dd6d449670e3a2fedf2d6f3806" => :catalina
    sha256 "d35fe4166d8371cf285e6b54fe3b92d380bb8932b9f307f3ba1d6f51650013d0" => :mojave
    sha256 "7bb4c80c9b516bc18ab034ef0d928d254212aec7d4ee34d43e3f94fe16115044" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/openfortivpn"
    system "make", "install"
  end
  test do
    system bin/"openfortivpn", "--version"
  end
end
