class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/refs/tags/1.10.0.tar.gz"
  sha256 "204b13487158b8e46bf6dd207757a52621148fdd1d2467ebd104de17493bab25"
  license all_of: [
    "GPL-3.0-or-later",
    "BSD-3-Clause", # mt19937ar.c
    "ISC", # strlcpy.c (Linux)
  ]
  head "https://github.com/royhills/arp-scan.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "a4212527be3b73cd4a5481e13014f6612f027139d5c0851ff3afca4f1828b137"
    sha256 arm64_sequoia:  "14249f8af1f8fa4a87cec61eeed1b7d2e15bdbdf917736eeb0a0fb5ec2be5b81"
    sha256 arm64_sonoma:   "bb46467cee8e1d7b24a8e7716cbdfacd2b8697c031d26a07658b8618557ff773"
    sha256 arm64_ventura:  "190e487560ceb1e564444c501f9bd814b2401d034e792a9c44b3d5f9a65ba720"
    sha256 arm64_monterey: "be3d37daa3c51629577fb423af1cec9549a7835673a737407a6746b529bbfc58"
    sha256 sonoma:         "f5b3e8d47b51e2c3e822b19727ba50a05016a90f1a8e4d446bc5c5a33bed2ba9"
    sha256 ventura:        "be308c8baf776004a152beedf6b75edccdd661090a6dfc09e6ac6580c156c784"
    sha256 monterey:       "7f00b162c2af2f64d8697ca0e7e7f11137b361ee59f8f2be04fcf674ff4ef54f"
    sha256 arm64_linux:    "6d668fdbe4f8a7a72ea57f3a0cdaa5791de6f46b30275e355bc294d0420bad02"
    sha256 x86_64_linux:   "18935cd6c4a1d707abca5e0d3b0119d696bf6f834714393b018650f973287656"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libpcap"

  conflicts_with "arp-scan-rs", because: "both install `arp-scan` binaries"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"arp-scan", "-V"
  end
end
