class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://github.com/ipmitool/ipmitool"
  url "https://github.com/ipmitool/ipmitool/archive/refs/tags/IPMITOOL_1_8_19.tar.gz"
  sha256 "48b010e7bcdf93e4e4b6e43c53c7f60aa6873d574cbd45a8d86fa7aaeebaff9c"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_ventura:  "a3862eb5a4f8f401f21f61585a6a51fd5c08a6825876122179c3286b68843943"
    sha256 arm64_monterey: "959def316be5f337341d13fd2225a7ebcafd775749d2fcde8ab23160de83e5c8"
    sha256 arm64_big_sur:  "3e711528ae7df03c387e4a25093e202d846ec2c11ab26b85f581abf24c20b3c0"
    sha256 ventura:        "d4b39179c103c299d23ca95a156f2ef009c37d335f9df30457a984b2579220a1"
    sha256 monterey:       "05de9ad2b49826138bfa4c777358af766bce8d80c4aeef3c59d072d9e8240c4b"
    sha256 big_sur:        "2e7da2c2ebe7ea60e20dd6aacfec261ac648a1eba952ea91536a0901bb4b6e05"
    sha256 x86_64_linux:   "a0a993a436ef12c14707d60293d37233dd90e0e80909c461f262c19874951d32"
  end

  deprecate! date: "2023-02-09", because: :repo_archived

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
