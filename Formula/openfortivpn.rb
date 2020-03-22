class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.13.1.tar.gz"
  sha256 "aa3cfe512bdcdbf8d4587dbb0543ee76bb3aebadb478bbbd94d87e174a61f011"

  bottle do
    sha256 "4cd992babeb67a972fd9696a77102171848ae0b8fc7539882c58df23acae4963" => :catalina
    sha256 "8a23a02cd67cb8d8fe0698bf083d85a92e3a5106548af4d57dcf97e5979e94d3" => :mojave
    sha256 "5481b7effe505f9974db9b8e6f948a7b07356db887bcef53a0ee560ff1c2222d" => :high_sierra
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
