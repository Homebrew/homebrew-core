class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%203.7/bittwist-macos-3.7.tar.gz"
  sha256 "800f04004ac0e2125ef250c308519432a124f352ef44d0eb10d608dd781f7472"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d1ef9f733d4e9ffdf117a5494809bd14fbbf23a12ea635f9b40b5a31a6a2a58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6fd55bf4870834fa763fec0fb243ec500c38e9dff48a7d7088639cf12356694"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f3abf6cdb986c994842ac2503163a3705fd90603f3163119454570e97db0575"
    sha256 cellar: :any_skip_relocation, ventura:        "48bb947457aaa6fb9005f63535de933579ce4779b2aa4defdd99f95cd6053ad6"
    sha256 cellar: :any_skip_relocation, monterey:       "1ac7704786b78d0a01b061942c0eb2dfda1c156f5f030a7d5afcec39ed2bf0e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4b41c3ce0bb9fff73b17998b857cab80a13f5154cb5bb75424982f76848289e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7da8fc66aeaa75bb225a301e339f925edba9d4a167afdd7b763213a91095151c"
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
