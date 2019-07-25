class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.11.6.tar.gz"
  sha256 "f8a07063b1e0890a1386fed2313a967f58f5495c075a25725aba200469c857bf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0e5e2392a311920e5238011bcd569d0bc8c958851c37385485c25e7128fa926f" => :mojave
    sha256 "3b138c66551e3a5a8cb8a92e4a3bec17c03078595a253fe388a048613da57f1f" => :high_sierra
    sha256 "f895d8f211e078832faa375991c0bf8247c2d70a24f7a71cb21c147399631797" => :sierra
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
