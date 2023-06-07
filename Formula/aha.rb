class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.5.1.tar.gz"
  sha256 "6aea13487f6b5c3e453a447a67345f8095282f5acd97344466816b05ebd0b3b1"
  license "LGPL-2.1"
  head "https://github.com/theZiz/aha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73761c6952a8eb254cf92b17f685bc1cb107d7f075e8e54ae97fc66bdf3b6707"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "638f024391f63bcaeb96fc614f0bd1d18ca42a42db7aaaacf939c5a473aa70b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fed59f6650f5b40100644b0baf1bee57b0b3ca6a05d413af70350d9d0eaa8441"
    sha256 cellar: :any_skip_relocation, ventura:        "3c9adaf83f5ed9e8a0f6c6596888f97199f18900c203765b86b658a72036c145"
    sha256 cellar: :any_skip_relocation, monterey:       "ea27c4b1e45d668521568a5d5e425dc607aadd74ac7378a6e100607a90330cbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "68281908da802d600716d979b84a47109fabd6770da0cc9a1a689b609b2024b8"
    sha256 cellar: :any_skip_relocation, catalina:       "bcd5f7ea0e30795e05719351823769f9a7ac434e57bf09cb738eeef50c0f0f85"
    sha256 cellar: :any_skip_relocation, mojave:         "b8def8fe2809928ffbf3ae5746f1157bacfef12e720d0eef798b4d77902d8f4f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9de609b23501a93b6fc39422bc51f4b79c31eba3c39272a06f2710aa7e2d6a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c018344a8a20792dbcc444893c62279ea87a97539e1cf0141ddf7b2cf538a9fb"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
