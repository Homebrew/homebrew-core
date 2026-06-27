class Mob < Formula
  desc "Tool for smooth Git handover in mob programming sessions"
  homepage "https://mob.sh"
  url "https://github.com/remotemobprogramming/mob/archive/refs/tags/5.4.2.tar.gz"
  sha256 "be6adc58ffd92cc21fd3fa96bb8eba48f9d3669ed3c1de1df568c37f3625664c"
  license "MIT"
  head "https://github.com/remotemobprogramming/mob.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13418fa5a5e3bfb0c8ee837ec2a28d16698a4f4200f59b1eae2afa28afa179f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13418fa5a5e3bfb0c8ee837ec2a28d16698a4f4200f59b1eae2afa28afa179f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13418fa5a5e3bfb0c8ee837ec2a28d16698a4f4200f59b1eae2afa28afa179f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "82a302a1e15a6a482acb992660a7888fb28fdfac9076df9ded8d6521a4782d51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3ad0c4d3a2f9c14b3b85b2f34376f236ec22d0688fff512dbe19e8d1d673ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e54e98de09b0cd50bdbb28d93f8dc1fd1e74d69270b218caa7d2a8acde48a0fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mob version")
    assert_match "MOB_CLI_NAME=\"mob\"", shell_output("#{bin}/mob config")
  end
end
