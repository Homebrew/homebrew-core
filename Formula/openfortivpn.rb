class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.20.1.tar.gz"
  sha256 "2d40ef67e188ebaa536e115263980c097e37c80afc4c2a1fd8cfa576aa616d5e"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_ventura:  "1e20140f29ff6464bab208319a6e354b5f901e8f606e2eaa15a038e14858e35d"
    sha256 arm64_monterey: "998fdd38c2a49f71032db7080f903145bb935d2d208bfce33c9169a2209554c3"
    sha256 arm64_big_sur:  "6fadba8b3269fdc7858878aeb6964a5de898cc2b37481a5a0ccb7e90ca2a7fff"
    sha256 ventura:        "8c665659c92748f15ccb99ac0996d3d2606dd28db7743cb93529b72793b9dc0b"
    sha256 monterey:       "7726a275dc6cdf004296fdf9e7154b3fc6bbd26682ce6774f2bbaeee93bfc850"
    sha256 big_sur:        "7f40301f138068b60a05bc991cb69707ba9183ea16ce04b0daa3e92c9cd1354d"
    sha256 x86_64_linux:   "1d0a65ed65ba9ce156414f7ee08998fa69ae34d2488f15694fd4edbda5d898fc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/openfortivpn"
    system "make", "install"
  end

  service do
    run [opt_bin/"openfortivpn", "-c", etc/"openfortivpn/openfortivpn/config"]
    keep_alive true
    require_root true
    log_path var/"log/openfortivpn.log"
    error_log_path var/"log/openfortivpn.log"
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end
