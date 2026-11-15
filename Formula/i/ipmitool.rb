class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://codeberg.org/IPMITool/ipmitool"
  url "https://codeberg.org/IPMITool/ipmitool/archive/IPMITOOL_1_8_19.tar.gz"
  sha256 "ce13c710fea3c728ba03a2a65f2dd45b7b13382b6f57e25594739f2e4f20d010"
  license "BSD-3-Clause"
  revision 3
  head "https://codeberg.org/IPMITool/ipmitool.git", branch: "master"

  livecheck do
    url :head
    regex(/^IPMITOOL[._-]v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "b7cb2691bf1d9efd8e53c2e5ec84a162f5c775cb8e4f27600d93b49f7cecdcf4"
    sha256 arm64_tahoe:       "fac2be6b6864c8ba04561644fa6c71fadd657c26725aab90ab009afcaf6ae437"
    sha256 arm64_sequoia:     "ace2463c31aa8323d12f23808698220aaf1a119fb599bc7996d757f3670bea5e"
    sha256 arm64_linux:       "9d8f46de91af22a4e3f4249d440cf15f3163148c94db6fa4de3fa64d42d22d2b"
    sha256 x86_64_linux:      "7ba2fa2ab338c124d5aab91f6aa0339c71fb774143fb2ec4eaa64f87dd581eb9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "readline"
  end

  # Patch to fix lan print
  patch do
    url "https://github.com/ipmitool/ipmitool/commit/a61349b443c16821e4884cde5ad8c031d619631a.patch?full_index=1"
    sha256 "e026b8a5a5128714a0f36d05b4b26428dca3522dc889ebc21dc8888a2d3f1505"
    type :unofficial
    resolves "https://github.com/ipmitool/ipmitool/pull/389",
             "https://github.com/ipmitool/ipmitool/issues/388"
  end

  # Patch to fix enterprise-number URL due to IANA URL scheme change
  patch do
    url "https://codeberg.org/IPMITool/ipmitool/commit/1edb0e27e44196d1ebe449aba0b9be22d376bcb6.patch?full_index=1"
    sha256 "044363a930cf6a9753d8be2a036a0ee8c4243ce107eebc639dcb93e1e412e0ed"
    type :backport
    resolves "https://github.com/ipmitool/ipmitool/issues/377"
  end

  # Patch to fix build on ARM
  patch do
    url "https://codeberg.org/IPMITool/ipmitool/commit/206dba615d740a31e881861c86bcc8daafd9d5b1.patch?full_index=1"
    sha256 "86eba5d0000b2d1f3ce3ba4a23ccb5dd762d01fec0f9910a95e756c5399d7fb8"
    type :backport
    resolves "https://github.com/ipmitool/ipmitool/issues/332"
  end

  deny_network_access!

  # Download file with curl instead of using a resource as it is updated
  # everyday without url change
  def fetch
    system "curl", "--output", buildpath/"enterprise-numbers", "http://www.iana.org/assignments/enterprise-numbers.txt"
  end

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--disable-intf-usb"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipmitool -V")
    if OS.mac?
      assert_match "No hostname specified!", shell_output("#{bin}/ipmitool 2>&1", 1)
    else # Linux
      assert_match "Could not open device", shell_output("#{bin}/ipmitool 2>&1", 1)
    end
  end
end
