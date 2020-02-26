class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.12.0.tar.gz"
  sha256 "ecad7d9998ee1be6cd263637333568f9b9fa72ba51f329a937f9e7db4bb3168a"

  bottle do
    sha256 "2a967fdaa6aa44291d6b4976fe2238c6b5436803bbff0c734d9100ae32d40935" => :catalina
    sha256 "6d11c5dc29ac39a519eae8e8dceade4f60225336c3d76a3a8be2f66e4b7cb1bf" => :mojave
    sha256 "9bb2e93944b6b3c1a85a8e9ba26f15994d32541367432acb1061f971e26322c7" => :high_sierra
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
