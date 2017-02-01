class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "http://ipmitool.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.18/ipmitool-1.8.18.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/ipmitool/ipmitool_1.8.18.orig.tar.bz2"
  sha256 "0c1ba3b1555edefb7c32ae8cd6a3e04322056bc087918f07189eeedfc8b81e01"
  revision 1

  bottle do
    cellar :any
    sha256 "09ab8411437d99d24051e033082c4f0868902fc6653010bc833a68c17dfc2577" => :sierra
    sha256 "79028e7c9ed529b3ec4bac14933350326320c24aeed1b172ea07f2fc39020720" => :el_capitan
    sha256 "df7ecf265d230af6f9a480348d386a9330149ac7e459f6cc98f47438f355516a" => :yosemite
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
