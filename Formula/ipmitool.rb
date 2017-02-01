class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "http://ipmitool.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.18/ipmitool-1.8.18.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/ipmitool/ipmitool_1.8.18.orig.tar.bz2"
  sha256 "0c1ba3b1555edefb7c32ae8cd6a3e04322056bc087918f07189eeedfc8b81e01"
  revision 1

  bottle do
    cellar :any
    sha256 "cb2a2bf53be4903cc5a236580ffbbb413555dabf93a8f734abbb8603e8d605af" => :sierra
    sha256 "4ea76b891b6180408d93f99d35aa670ea30f53e3a4ba459594b942574317d4d6" => :el_capitan
    sha256 "01379e99808989b8cf73fb741529c01fcde2346bc58614fcdb5c38239bbdd33e" => :yosemite
  end

  depends_on "openssl"

  def install
    # Fix ipmi_cfgp.c:33:10: fatal error: 'malloc.h' file not found
    # Upstream issue from 8 Nov 2016 https://sourceforge.net/p/ipmitool/bugs/474/
    inreplace "lib/ipmi_cfgp.c", "#include <malloc.h>", ""

    # https://sourceforge.net/p/ipmitool/bugs/436/
    ENV.append "CFLAGS", "--std=gnu99"
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-intf-usb
    ]
    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    # Test version print out
    system bin/"ipmitool", "-V"
  end
end
