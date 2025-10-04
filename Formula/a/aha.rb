class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/refs/tags/0.5.1.tar.gz"
  sha256 "6aea13487f6b5c3e453a447a67345f8095282f5acd97344466816b05ebd0b3b1"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]
  head "https://github.com/theZiz/aha.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c5c635a3945439e2666c6387fc7adf040ae53448b69cdd10ead335c19238abe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "16696aeddc832f4f9f7c61ce7d3e6a8327f229bdeb941aded1bce4b2285f8470"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1df76aba65188e22f99b5229fdfc0435cd0e1e747d8596e64cee739bb679fb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73761c6952a8eb254cf92b17f685bc1cb107d7f075e8e54ae97fc66bdf3b6707"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "638f024391f63bcaeb96fc614f0bd1d18ca42a42db7aaaacf939c5a473aa70b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fed59f6650f5b40100644b0baf1bee57b0b3ca6a05d413af70350d9d0eaa8441"
    sha256 cellar: :any_skip_relocation, sonoma:         "759a0282561b295214bc58c2ef10c3e0209a499dd03431e72aad7279eb26cc56"
    sha256 cellar: :any_skip_relocation, ventura:        "3c9adaf83f5ed9e8a0f6c6596888f97199f18900c203765b86b658a72036c145"
    sha256 cellar: :any_skip_relocation, monterey:       "ea27c4b1e45d668521568a5d5e425dc607aadd74ac7378a6e100607a90330cbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "68281908da802d600716d979b84a47109fabd6770da0cc9a1a689b609b2024b8"
    sha256 cellar: :any_skip_relocation, catalina:       "bcd5f7ea0e30795e05719351823769f9a7ac434e57bf09cb738eeef50c0f0f85"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "da606271d62f24440590f2b791073d6507f1eeff55f96134023dea46464e0095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c018344a8a20792dbcc444893c62279ea87a97539e1cf0141ddf7b2cf538a9fb"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m", 0)
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
