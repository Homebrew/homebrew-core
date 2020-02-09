class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.12.2.tar.gz"
  sha256 "ac288b047d1156fc5e739062b11242bad0487993631e79781aede620ddf18cd7"

  bottle do
    cellar :any
    sha256 "31a8219cf9008c4f14b9bbbf962bcc9ab1ae2a3225b83257a3a2534d993e0d4c" => :catalina
    sha256 "4bc0298e1059a8da833a8cc73b01fd3705fef61931b1be30f7132180f9083fbc" => :mojave
    sha256 "113d1a55a25b57615189749651a3d69b6573d587baf06000beb0d8733f9d62fa" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libmpc"
  depends_on "libunistring"
  depends_on "unbound"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
