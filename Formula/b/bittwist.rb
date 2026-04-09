class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%204.7/bittwist-macos-4.7.tar.gz"
  sha256 "2ff00070d57221672af5198268088ffee8ed6b5ade33d6f26be5b3b4125b48f1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7b5eded04554c702c03d007fc3154db054b0e2626fdf96cc7f3deb5507c3565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e8c5033fb2ebd8dc27832f1b4252d3f1b4cfadee39831d6af68028f28f9e8e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364a968f6b30db2db01a77f6b2c55c609d3c8165607c40e0f2b4b1ea011c81c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f5fe1bc269cc3195450240348b9b808f60b19c88b1362a533ef7f615d6b7c40"
    sha256 cellar: :any_skip_relocation, sonoma:        "523fc5af61f3f3815d23cfbc1089548d86b072a301c5424923cdac4028a61d95"
    sha256 cellar: :any_skip_relocation, ventura:       "3df91f28e930a032ea31108f1ceb250b14d0a02b5026060924027457426183b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e718fe79ba09665d846a8479a6ff2cb593540e48aa477114322af1bab5ccdc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f85b61e9d72e5d329a7b3a01813b01f2c72e81dc451bf144e8860b0cd868472d"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"bittwist", "-help"
    system bin/"bittwiste", "-help"
  end
end
