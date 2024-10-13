class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://codeberg.org/IPMITool/ipmitool"
  url "https://codeberg.org/IPMITool/ipmitool/archive/IPMITOOL_1_8_19.tar.gz"
  sha256 "ce13c710fea3c728ba03a2a65f2dd45b7b13382b6f57e25594739f2e4f20d010"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^IPMITOOL[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sequoia:  "e634c21dfd6a2f2966ea44cd06769913da9063173243544dc37581ffe997c12c"
    sha256 arm64_sonoma:   "706bd54ab2e1ba25915652b20b40a3fcef4611e185c5a6910a4c2b73d737df2b"
    sha256 arm64_ventura:  "9c793c56cdb44aab31470708ab208e9525d4a5782b313f3cf7dd12fad2759275"
    sha256 arm64_monterey: "c19e86e32583bceb9c38f2232c90726b2a529857d24638e62e355ad47eb8bfdb"
    sha256 arm64_big_sur:  "d8e13a2e7d3c9bb7cb0f04aaeb559154685ca752247b0ebf45ee9c3e4e85fdfc"
    sha256 sonoma:         "3c4a0d31ca3b729ae30dc91019f4e1c6359b753f8973149f444d78fb644d585b"
    sha256 ventura:        "3f390f62eceea1ff43f989033f099f54a0f9f006b915e4f60b044dd6c9473a09"
    sha256 monterey:       "9977d1fe240ac918fe0f2a2468a4fa451faf3a442b0136dd490cc58d02b2898b"
    sha256 big_sur:        "18a570a5c08115eada019cd65b3a889e51f950ba9efed6bd1cb82864ff3661f7"
    sha256 x86_64_linux:   "3642f1f3d4daa7d79df5394683be422345f2c397fc01febd9f4ad75e751c92c8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "readline"
  end

  # fix enterprise-number URL due to IANA URL scheme change
  # remove in next release
  patch do
    url "https://codeberg.org/IPMITool/ipmitool/commit/1edb0e27e44196d1ebe449aba0b9be22d376bcb6.patch?full_index=1"
    sha256 "044363a930cf6a9753d8be2a036a0ee8c4243ce107eebc639dcb93e1e412e0ed"
  end

  # Patch to fix build on ARM
  # https://github.com/ipmitool/ipmitool/issues/332
  patch do
    url "https://codeberg.org/IPMITool/ipmitool/commit/206dba615d740a31e881861c86bcc8daafd9d5b1.patch?full_index=1"
    sha256 "86eba5d0000b2d1f3ce3ba4a23ccb5dd762d01fec0f9910a95e756c5399d7fb8"
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
