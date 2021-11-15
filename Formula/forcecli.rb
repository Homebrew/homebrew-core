class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.32.0.tar.gz"
  sha256 "6ece64315c576eac8d5650fb1d8f1895b5810d268355d2c4b0e83fcea8bb9a5f"
  license "MIT"
  head "https://github.com/ForceCLI/force.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2104638f28f680848e219fbe3ad57988306b4ea25d6bb06fb04a451d3feaecb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0549f14810f77112b8d642c6453dc636adb519ee072ec993e98d1cabf2dd8380"
    sha256 cellar: :any_skip_relocation, monterey:       "6c6110abb43a3e522a9201c464b26c9cc85c30d3b2d36df32bca739fe2994584"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bffce24112b4e7c120964811bd779e95a6153ba1bc5951a99ebdec81dfa8e9c"
    sha256 cellar: :any_skip_relocation, catalina:       "1772f7e189f229021992d27874c7c417eb5765b888ccf051ab1a6a5cd560540e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be83b963b60e9b15475d6a3558b9d172d2b7a4255de1287137900a04e266fc5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
