class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.5.1.tar.gz"
  sha256 "6aea13487f6b5c3e453a447a67345f8095282f5acd97344466816b05ebd0b3b1"
  license "LGPL-2.1"
  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68281908da802d600716d979b84a47109fabd6770da0cc9a1a689b609b2024b8" => :big_sur
    sha256 "fed59f6650f5b40100644b0baf1bee57b0b3ca6a05d413af70350d9d0eaa8441" => :arm64_big_sur
    sha256 "bcd5f7ea0e30795e05719351823769f9a7ac434e57bf09cb738eeef50c0f0f85" => :catalina
    sha256 "b8def8fe2809928ffbf3ae5746f1157bacfef12e720d0eef798b4d77902d8f4f" => :mojave
    sha256 "9de609b23501a93b6fc39422bc51f4b79c31eba3c39272a06f2710aa7e2d6a3f" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
