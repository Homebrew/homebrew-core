class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.13.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.13.2.tar.gz"
  sha256 "b615702e701b4569663767a9da72f33c9778bc853b20d1c811b25ec8fb328a2c"
  license "AGPL-3.0"

  bottle do
    cellar :any
    sha256 "ac396db25d2f21a17974afdc2dade1a03813fe2348b94d71a15512d17c275bcf" => :catalina
    sha256 "1d2b9418f9d932da8c5f17a52c7660616921b296502b0076b1b16d1a83fcaab9" => :mojave
    sha256 "41064ea3cb2a9eb7d34f35146fe03876d13edcd8a2db2008c1fe1ddb2faf6620" => :high_sierra
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
