class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.11.0.tar.gz"
  sha256 "b7477a3c3b0d5e8a013685dc208cfb4ccee4145f8668faa8eb5b382af36c7e9a"

  bottle do
    cellar :any
    sha256 "75b4cf083ad9ea4eef073bc85d055ca77b132b11b7662dd551eef38bb98425f0" => :mojave
    sha256 "c0741fe2c1022bab077c8c51bbd88d9b282d22d8397bea3a998230da36721741" => :high_sierra
    sha256 "c9a15f3fef28fd1e6004829be29e85c14b66caf6b6c57596dd03909fa239f918" => :sierra
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

    # Move non executable script away from bin
    mv bin/"gnunet-qr.py", pkgshare
    inreplace bin/"gnunet-qr", bin, pkgshare
  end

  test do
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
