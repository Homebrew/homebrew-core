require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.6.0",
      revision: "48cf6adee52dc37ab5c04fcfdfdaa1b38155caef"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "59490e2cd622b6e0507f36d2ae3bb326e1e96a3ad812436047292c3cd58d6f9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c897e38d3d5b53c875d6b7166fde810c5463f403c661900771e90b6366f7ed7"
    sha256 cellar: :any_skip_relocation, catalina:      "15a8024d138f4dc0cbef2e9c28c35d777001df73f4f44f6a411d121af2753e98"
    sha256 cellar: :any_skip_relocation, mojave:        "0d3caa18bd84c1058de35ed4f0bc0a073ac8b84d48089370095704546f72770e"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/copilot", "completion", "bash")
    (bash_completion/"copilot").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/copilot", "completion", "zsh")
    (zsh_completion/"_copilot").write output
  end

  test do
    assert_match "Welcome to the Copilot CLI! We're going to walk you through some questions",
      shell_output("#{bin}/copilot init 2>&1", 1)

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("#{bin}/copilot pipeline init 2>&1", 1)
  end
end
