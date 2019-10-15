class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.11.6.tar.gz"
  sha256 "f8a07063b1e0890a1386fed2313a967f58f5495c075a25725aba200469c857bf"

  bottle do
    cellar :any
    sha256 "0e18edb895b087a4cf4520957b425bac128e6ccf0957f14867330d1ab292e229" => :catalina
    sha256 "88e4b7b5b5e022db9e02d4eaa0784aca48971fea93b16043bc7ae8326927431e" => :mojave
    sha256 "c2c95aa8b1b3c17d164863ec853ea7e109072cbdeee61904e6eff7121a931f15" => :high_sierra
    sha256 "ae1fa4e8cb8ccc335c2170f7ca180e2b5685836a869409e4774180319f53d9d4" => :sierra
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
