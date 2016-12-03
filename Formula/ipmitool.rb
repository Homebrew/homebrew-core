class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "http://ipmitool.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.18/ipmitool-1.8.18.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/ipmitool/ipmitool_1.8.18.orig.tar.bz2"
  sha256 "0c1ba3b1555edefb7c32ae8cd6a3e04322056bc087918f07189eeedfc8b81e01"

  bottle do
    cellar :any
    sha256 "460e61ff8bede01a062eca0fdc489b1b4563327a41eda10fa2fd4c96a06561dc" => :sierra
    sha256 "3e36dbf39144cf9dd90cef46f5f8bb55e1fed1a8351f410bb2329c585750a6d2" => :el_capitan
    sha256 "a3ed251ff9008a7e77af4abf35f5b065c9ead124f00aba63f22da20b34863411" => :yosemite
    sha256 "99b52bd33e47acc539d407a254c15255c8ec1b6d61de0c1cb758a43126af3529" => :mavericks
  end

  depends_on "openssl"

  def install
    # Required to get NI_MAXHOST and NI_MAXSERV defined in /usr/include/netdb.h, see
    # https://sourceforge.net/p/ipmitool/bugs/418
    inreplace "src/plugins/ipmi_intf.c", "#define _GNU_SOURCE 1", "#define _GNU_SOURCE 1\n#define _DARWIN_C_SOURCE 1"

    # Fix ipmi_cfgp.c:33:10: fatal error: 'malloc.h' file not found
    # Upstream issue from 8 Nov 2016 https://sourceforge.net/p/ipmitool/bugs/474/
    inreplace "lib/ipmi_cfgp.c", "#include <malloc.h>", ""

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-intf-usb"
    system "make", "install"
  end

  test do
    # Test version print out
    system bin/"ipmitool", "-V"
  end
end
