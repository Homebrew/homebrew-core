class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.13.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.13.1.tar.gz"
  sha256 "03d76a852e7fd2fc87b7145cb6abd900f73e4ea6097f3caac9e7d9fe8b625696"
  license "AGPL-3.0"

  bottle do
    cellar :any
    sha256 "bcef73933e829bc7fd6a52928f33087dd1261ab879735e58d99801305ef3649f" => :catalina
    sha256 "6c0fa2f4d6c274b3273e6c2f8f290d28c0bec457b887041b4d9f1defc3d5abae" => :mojave
    sha256 "bb24f051b036b4729d52937c6b31b790ffff064f327a34ccaf563279ec809db9" => :high_sierra
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
