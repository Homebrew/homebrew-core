class Mob < Formula
  desc "Tool for smooth Git handover in mob programming sessions"
  homepage "https://mob.sh"
  url "https://github.com/remotemobprogramming/mob/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "9082fa79688a875a386f9266e4f09efaeff5d14ad1288a710f6fb730974f3040"
  license "MIT"
  head "https://github.com/remotemobprogramming/mob.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea259acacda5e76abcb29c2291753b5567acc90d86d7e698645b48cfe5eb4a21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea259acacda5e76abcb29c2291753b5567acc90d86d7e698645b48cfe5eb4a21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea259acacda5e76abcb29c2291753b5567acc90d86d7e698645b48cfe5eb4a21"
    sha256 cellar: :any_skip_relocation, sonoma:        "edd877ddebf533a27a61a45d4ffe44b909678a3fac5d80883e6cd73c33a45284"
    sha256 cellar: :any_skip_relocation, ventura:       "edd877ddebf533a27a61a45d4ffe44b909678a3fac5d80883e6cd73c33a45284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a41769e9089f0fb440df59c22add6b1578b1b445c7cdae53496126d7283caa74"
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
