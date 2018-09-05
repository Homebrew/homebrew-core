class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://ipmitool.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.18/ipmitool-1.8.18.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/ipmitool/ipmitool_1.8.18.orig.tar.bz2"
  sha256 "0c1ba3b1555edefb7c32ae8cd6a3e04322056bc087918f07189eeedfc8b81e01"
  revision 2

  bottle do
    cellar :any
    sha256 "80039ed77975cdfc9b50ce83750b28be15dca7506c482cc43e60791359ac4240" => :mojave
    sha256 "ffea0646f0d1ce2d773f1566fe813e36c3ab8d409ad26580c87709d696401fd4" => :high_sierra
    sha256 "c7e13ccde0f639c52aa915a71f9779ec0b514ed1260c5c9078754498f80c9ec3" => :sierra
    sha256 "d6ce46b2b93ac040cb3ac235bd68ecab496b8dbebee22fb4fb69ad52aa75e9c9" => :el_capitan
    sha256 "5e9ad832c757416534a30df441ba41f83a4634bb80c224d4e42e7395b58cb9a6" => :yosemite
  end

  depends_on "openssl"

  # https://sourceforge.net/p/ipmitool/bugs/433/#89ea and
  # https://sourceforge.net/p/ipmitool/bugs/436/ (prematurely closed):
  # Fix segfault when prompting for password
  # Re-reported 12 July 2017 https://sourceforge.net/p/ipmitool/mailman/message/35942072/
  patch do
    url "https://gist.githubusercontent.com/adaugherity/87f1466b3c93d5aed205a636169d1c58/raw/29880afac214c1821e34479dad50dca58a0951ef/ipmitool-getpass-segfault.patch"
    sha256 "fc1cff11aa4af974a3be191857baeaf5753d853024923b55c720eac56f424038"
  end

  def install
    # Fix ipmi_cfgp.c:33:10: fatal error: 'malloc.h' file not found
    # Upstream issue from 8 Nov 2016 https://sourceforge.net/p/ipmitool/bugs/474/
    inreplace "lib/ipmi_cfgp.c", "#include <malloc.h>", ""

    args = %W[
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
