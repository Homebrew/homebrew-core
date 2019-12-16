class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.11.0.tar.gz"
  sha256 "95db77566376f4504547b6407b249f007f2edf63b85ffe999436a999569645b6"

  bottle do
    sha256 "2a967fdaa6aa44291d6b4976fe2238c6b5436803bbff0c734d9100ae32d40935" => :catalina
    sha256 "6d11c5dc29ac39a519eae8e8dceade4f60225336c3d76a3a8be2f66e4b7cb1bf" => :mojave
    sha256 "9bb2e93944b6b3c1a85a8e9ba26f15994d32541367432acb1061f971e26322c7" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
