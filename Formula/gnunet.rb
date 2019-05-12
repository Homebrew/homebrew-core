class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.11.4.tar.gz"
  sha256 "7afeb638bd8b5a33c6b8dab24b90c5d7467439adc79794ff33218e9180f8b01b"

  bottle do
    cellar :any
    sha256 "eaf730b8c1addd4e70ac0b140251e3e8e14f7bc85756f52505084501e6e9c1c0" => :mojave
    sha256 "c540a88c2865954f03daa09234efc1239fb2b73773b2ad9f77b87989840b9bbd" => :high_sierra
    sha256 "a39d9d76776cd71b1578a141c4ea37bc3e19aa8ad29dd744e198784d88966f72" => :sierra
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
