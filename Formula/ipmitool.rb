class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://github.com/ipmitool/ipmitool"
  url "https://github.com/ipmitool/ipmitool/archive/refs/tags/IPMITOOL_1_8_19.tar.gz"
  sha256 "48b010e7bcdf93e4e4b6e43c53c7f60aa6873d574cbd45a8d86fa7aaeebaff9c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3223279b0188313a5d87ede24617f6bda5921acc1ce135c30c7c43823f14913f"
    sha256 cellar: :any,                 monterey:      "498392b8b88c12f88c9e417270b7ba736619070af521750381b487b8c972d37c"
    sha256 cellar: :any,                 big_sur:       "6dd8c02b3e556949c98d40980dd9c1b456d1fa078d9d7792f36977e7d239a4ac"
    sha256 cellar: :any,                 catalina:      "926d5c49a0a1b9411e45c54e412403003266c27127059edb50b40e07adaf2260"
    sha256 cellar: :any,                 mojave:        "3bf8d00d62c2e1dc781493d448062ad365ac8e7c73010ee37ba2040a48513c10"
    sha256 cellar: :any,                 high_sierra:   "04462f0b4129d34cbf7e8e5c72591360e89dd6d6cef20008567015d57ab611c4"
    sha256 cellar: :any,                 sierra:        "f08f0e5717ff8ccf031ca738eb4995b39db5d37b802800b6e0b6c154f6fed830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34d7e08574ee45e07c513a90b38c7de24636f7889e940daf8f0d87c3a9739977"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--disable-intf-usb"
    system "make", "check"
    system "make", "install"
  end

  test do
    # Test version print out
    system bin/"ipmitool", "-V"
  end
end
