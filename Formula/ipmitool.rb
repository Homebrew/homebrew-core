class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://github.com/ipmitool/ipmitool"
  url "https://github.com/ipmitool/ipmitool/archive/refs/tags/IPMITOOL_1_8_19.tar.gz"
  sha256 "48b010e7bcdf93e4e4b6e43c53c7f60aa6873d574cbd45a8d86fa7aaeebaff9c"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "eedcd4c1fce5ff3dabb6dc2ec82edb04d21a1d14d2174976719403e2b8c92f38"
    sha256 arm64_monterey: "dd6910b46efcf9ff2c57a613204ef21f0c0c51a3aeea353d270824edc8e51d60"
    sha256 arm64_big_sur:  "ead2f3d6123ca51af690637b4b9a9820bd2c3ce6d9ce2e837c3970fe6bafc2f0"
    sha256 ventura:        "176c0d710be65afe8949ddb016bdf86c7829e476f06efc49a435001e6d73be8f"
    sha256 monterey:       "c54b37fb1277bf5bea3be2ea71644864ab8abfbdbe9ab37e27b875116089d439"
    sha256 big_sur:        "0cc29edd4db4889608169415905299c268dfd44698734a529fdf616b560097a3"
    sha256 x86_64_linux:   "ed7f7643e9d022a4ebc674018b9ac1731c6bc03fbb3943d6d13e6820ea55a84e"
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
    url "https://github.com/ipmitool/ipmitool/commit/1edb0e27e44196d1ebe449aba0b9be22d376bcb6.patch?full_index=1"
    sha256 "c7df82eeb6abf76439ca9012afdcef2e9e5ab5b44d4a80c58c7c5f2d8337bc83"
  end

  # Patch to fix build on ARM
  # https://github.com/ipmitool/ipmitool/issues/332
  patch do
    url "https://github.com/ipmitool/ipmitool/commit/a45da6b4dde21a19e85fd87abbffe31ce9a8cbe6.patch?full_index=1"
    sha256 "98787263c33fe11141a6b576d52f73127b223394c3d2c7b1640d4adc075f14d5"
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
