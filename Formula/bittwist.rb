class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%203.1/bittwist-macos-3.1.tar.gz"
  sha256 "88d1870f8ba9050e0fc89b96501b71155d76d9855f4eadf81258ade07e439d5e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dbd2f2b385f253d0b2adcf076c8c71836a153934c273fc1ef429d44faa4d78a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23c74492b097bdc7ccd53a2eef8065793a2d130a06a338953591b0a36b8d463e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bae24b9cd57deba3efa2047cd75f2cfa020b9121855933eeeb67dafc59944cd8"
    sha256 cellar: :any_skip_relocation, ventura:        "cf77a149cb319450d0b04f3c3d46538828d1187c7df3e3c29d49906b91f9f489"
    sha256 cellar: :any_skip_relocation, monterey:       "716fcfbc18d08fa5cc7dc9c28391127a76e35a46c12ebbd92a1ba2c9c1acf024"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1112494b4d22a954a7a58667a2c81e00d02c85e97433dbc3eb416209fbfce76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e87220f23b6e808c71055923a28b09a67877a98ac7d8bf7bffbefaea7e96f27b"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist", "-help"
    system "#{bin}/bittwiste", "-help"
  end
end
