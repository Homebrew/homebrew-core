class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.17.2.tar.gz"
  sha256 "0f3f3c767cb8bf81418a0fc7c6ab7636c574840c3b6a95c50901c3e1a09c079a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "4416e29cdcd1cea5a67b9f43a884379b42d4a1182c343ca00282508736e936dd"
    sha256 arm64_big_sur:  "841251f14102aac8428f452673c59802c53f15704a76c90378777a70e1eae92e"
    sha256 monterey:       "0f556551fb7844bb8954e02256c03270442a259a54ddfe006bfa1cb66f724488"
    sha256 big_sur:        "ccc9bb9f730dfe2042b1122075a489a21a0e2670a6476629ee3378a8dcbe30be"
    sha256 catalina:       "0b29d6c3803757515db40e0c9316fabed9d3eff7487a02f074ae52fe431f95e6"
    sha256 x86_64_linux:   "816c71078dd6b6a17409595e226409de00d6c25614460ca708f6340b3b1c7db2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/openfortivpn"
    system "make", "install"
  end
  test do
    system bin/"openfortivpn", "--version"
  end
end
