class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.14.1.tar.gz"
  sha256 "bc62fc6ecaaa6c6f8f2510e14a067a0cb9762158d9460c04555990bba44b50ca"

  bottle do
    sha256 "0005000f9bb563bfbdccb19c4c65ffd20650d9a01f73e4a209702a6eedce19b6" => :catalina
    sha256 "0023f59f2bf8671fc626d69fecf1ef672cef39a901cc0a98e75c9a82f6db3759" => :mojave
    sha256 "6b3a2ba4f60dc36e7e61dd0d5a882ace939b5fdc07e1dbcd9814559a52185456" => :high_sierra
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
