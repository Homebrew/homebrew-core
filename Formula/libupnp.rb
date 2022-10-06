class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.14/libupnp-1.14.14.tar.bz2"
  sha256 "3ae23a2f2dbe3c4fe845a14d114d092743dac1184d024a8e900c2d3e78362150"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "07f8ecbee06854dc6072b10e80840e720523d82d43f5bec5bf1e4ec7da4522b8"
    sha256 cellar: :any,                 arm64_big_sur:  "1b20e444ebcf0d98931a66965781221ca4350c14f938e36436ab9dbada82a473"
    sha256 cellar: :any,                 monterey:       "7944d7c54c3fd7b339ced4aa400eeba7abc4f141115e0c7b9894d9b73f5667c4"
    sha256 cellar: :any,                 big_sur:        "7d977eeb2e8a51f28cb9e026f704c7bb8259950126ad4bccee08b646a52e8ee3"
    sha256 cellar: :any,                 catalina:       "b67e74278edf97fd18131b1291f8d1e39a76065fd23174db1df1d4591aee3452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad9fa3404c5fefb005c2059664f877db34ef253cd049cb0513077e6fc59f4b0e"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
