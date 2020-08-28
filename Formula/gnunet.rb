class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.13.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.13.2.tar.gz"
  sha256 "b615702e701b4569663767a9da72f33c9778bc853b20d1c811b25ec8fb328a2c"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "3c504480a83dc1c28802cae7e964b3516df3b8b40676bdc124bdf7e45b950fbe" => :catalina
    sha256 "70800264e8f098e64d4ff805adbf483a6f146414976ef2dc5492c44ba93d5cb8" => :mojave
    sha256 "d2b897256e0e17e2d8e0c4c905787a72341939ffefe1c6d669437a1a44bd48ef" => :high_sierra
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
  depends_on "libsodium"
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
