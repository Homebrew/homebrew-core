class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.12.1.tar.gz"
  sha256 "5553014dfa8b9aefa96fe83c6a8b8a84a28b30655df0ce283fd3e44a5a1b1f7e"

  bottle do
    cellar :any
    sha256 "094916ba2a9bab9c449b1c8047109b0f855ab26a6abd3937b60d15ed9297a8a6" => :catalina
    sha256 "64bd9251aa9af2bd099907c6dde15b594ab99061791e97c1b30c20649d79cf33" => :mojave
    sha256 "3e4a08fabc3b684375834eb592b1e11468ae82f27a71734b21f6134e1173bc72" => :high_sierra
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
