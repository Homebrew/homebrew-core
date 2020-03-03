class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.12.0.tar.gz"
  sha256 "ecad7d9998ee1be6cd263637333568f9b9fa72ba51f329a937f9e7db4bb3168a"

  bottle do
    sha256 "4cd992babeb67a972fd9696a77102171848ae0b8fc7539882c58df23acae4963" => :catalina
    sha256 "8a23a02cd67cb8d8fe0698bf083d85a92e3a5106548af4d57dcf97e5979e94d3" => :mojave
    sha256 "5481b7effe505f9974db9b8e6f948a7b07356db887bcef53a0ee560ff1c2222d" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # Fix incompatibility with macOS sed. Remove with next release.
  patch do
    url "https://github.com/adrienverge/openfortivpn/commit/527265ea58dee643a8f2890e1ed021558b95fdea.patch?full_index=1"
    sha256 "8e73a74399a6331b9eb2e136a9f5e65e25c52a59fd2ac5aa4a4141baf81e14f1"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    system bin/"openfortivpn", "--version"
  end
end
