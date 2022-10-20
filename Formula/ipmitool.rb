class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://github.com/ipmitool/ipmitool"
  url "https://github.com/ipmitool/ipmitool/archive/refs/tags/IPMITOOL_1_8_19.tar.gz"
  sha256 "48b010e7bcdf93e4e4b6e43c53c7f60aa6873d574cbd45a8d86fa7aaeebaff9c"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "2e6e3fea7a8cadd51398d01f72cd0006ebe5ec829d507dea76a5a95d7edd5272"
    sha256 monterey:      "77afdfc5d78d5bf3648ad8735ceeebc0bd9e828cc4745ae8a3f9bb9a21bf84d0"
    sha256 big_sur:       "48374423f791ed6480c95f1ab3b3dd1b3b001d26fd10209d381a6cdf345881c5"
    sha256 catalina:      "6150b711f1eadfc1efe639b27f499394c45e06c2a72effacf76136f8d5ad9d2f"
    sha256 x86_64_linux:  "8724e4c0d6db47b52c350a243ea96e512dbd277e3265e54adc22cc44f4e9df39"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--disable-intf-usb"
    system "make", "check"
    system "make", "install"
  end

  test do
    # Test version print out
    system bin/"ipmitool", "-V"
  end
end
