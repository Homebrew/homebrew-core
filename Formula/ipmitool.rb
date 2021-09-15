class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://github.com/ipmitool/ipmitool"
  url "https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.18/ipmitool-1.8.18.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/i/ipmitool/ipmitool_1.8.18.orig.tar.bz2"
  sha256 "0c1ba3b1555edefb7c32ae8cd6a3e04322056bc087918f07189eeedfc8b81e01"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3223279b0188313a5d87ede24617f6bda5921acc1ce135c30c7c43823f14913f"
    sha256 cellar: :any,                 big_sur:       "6dd8c02b3e556949c98d40980dd9c1b456d1fa078d9d7792f36977e7d239a4ac"
    sha256 cellar: :any,                 catalina:      "926d5c49a0a1b9411e45c54e412403003266c27127059edb50b40e07adaf2260"
    sha256 cellar: :any,                 mojave:        "3bf8d00d62c2e1dc781493d448062ad365ac8e7c73010ee37ba2040a48513c10"
    sha256 cellar: :any,                 high_sierra:   "04462f0b4129d34cbf7e8e5c72591360e89dd6d6cef20008567015d57ab611c4"
    sha256 cellar: :any,                 sierra:        "f08f0e5717ff8ccf031ca738eb4995b39db5d37b802800b6e0b6c154f6fed830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34d7e08574ee45e07c513a90b38c7de24636f7889e940daf8f0d87c3a9739977"
  end

  depends_on "openssl@1.1"

  # https://sourceforge.net/p/ipmitool/bugs/433/#89ea and
  # https://sourceforge.net/p/ipmitool/bugs/436/ (prematurely closed):
  # Fix segfault when prompting for password
  # Re-reported 12 July 2017 https://sourceforge.net/p/ipmitool/mailman/message/35942072/
  patch do
    url "https://gist.githubusercontent.com/adaugherity/87f1466b3c93d5aed205a636169d1c58/raw/29880afac214c1821e34479dad50dca58a0951ef/ipmitool-getpass-segfault.patch"
    sha256 "fc1cff11aa4af974a3be191857baeaf5753d853024923b55c720eac56f424038"
  end

  # Patch for compatibility with OpenSSL 1.1.1
  # https://reviews.freebsd.org/D17527
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/10f4f68f/ipmitool/openssl-1.1.diff"
    sha256 "8ad4e19d7c39d1bf95a0219d03f4d8490727ac79cb297a36639443ef030bb76a"
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
