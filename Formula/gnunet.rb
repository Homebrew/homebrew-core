class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.11.4.tar.gz"
  sha256 "7afeb638bd8b5a33c6b8dab24b90c5d7467439adc79794ff33218e9180f8b01b"

  bottle do
    cellar :any
    sha256 "8a28d2c64bf814bcd629b66715b553bee3031c05f98075dd0f1bc79acb4fe840" => :mojave
    sha256 "9fc7995800f8c74266313e9ccc274b625debc4033221dae729936821400a4c87" => :high_sierra
    sha256 "c75feb5d2bfcb379c0025645d0d8ab7c2e5fce938901ec53c841bbeafbf684c1" => :sierra
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
