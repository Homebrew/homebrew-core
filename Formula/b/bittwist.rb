class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%203.8/bittwist-macos-3.8.tar.gz"
  sha256 "d3abce2703406115f257765c40b75eb5f45f01fe61e42a2e77e38a93aece22d0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58ddcb2879c84669c338f51c8539e51230b074f31cf854ddc2dd086202c92431"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "340d68a07b0e0e3b35d5033a0d374aa33d3b83507566f17f4f7fc84d120947fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73652da4ecec5d1abee5d6b677044a14479bf0825b27f2535e4fa9092e6e2b1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fe5bc474fd586b73e79eb183604227698dd6082d3aa02833338348d177d696d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2be49e4aa52632a2623f39762f32938458844e48db27eae7ca7e4f1604d18486"
    sha256 cellar: :any_skip_relocation, ventura:        "37c8abaad02d566504a4e159b9b1f276f33ef938c5c3ccb07a3afb911f308ee7"
    sha256 cellar: :any_skip_relocation, monterey:       "77b38e9fb9ecfe31bbae1d430d1c63748b2c7d77377fb6a34d82ff99a3329240"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5eb62aef4579495f97ef94b6f0c092257b8c994ae7742cda6611c6820d140a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c8f5e60580874c7527a5309ebcdd9a3d3f36989a07599b9f17592b8784340d2"
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
