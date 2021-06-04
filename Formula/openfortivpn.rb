class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.16.0.tar.gz"
  sha256 "599b1e159a03be557242aa0e693bb7ddbadf2a4a2b3ffcf77dc15459fe7f6cd6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "fe329fa78d439d21525954fcfe7e4b5181d818314fb198bfb43302a6935c7b4f"
    sha256 big_sur:       "2b8aa8b10b0df068e05972daf48054f3a05716a7d5936824f87ef59f90492bf3"
    sha256 catalina:      "2461050389b1e6ca991b92ca1baed5efa4f913f4dfaf4b356083d4c6a7a2a0b4"
    sha256 mojave:        "f70377cd7929889951bce6216b25e5429aba924d111be44a1c24904a46adcd91"
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
