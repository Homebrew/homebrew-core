require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.19.0",
      revision: "33ee39e861e148867b7ecb62f6dc46d50ac5c5e4"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf257437a7895ef97236848f03289b997f5c2f5b589b22f6dd1bddba575b1b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b360c97972454aaa62c98ec75863854add42a7814faed534d3ff4c8546d923d3"
    sha256 cellar: :any_skip_relocation, monterey:       "6e731790caff71838817b8bff770f4ca831abcce9d8d1a6a98f19694d787e707"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1392463ccecd465be08a2cf727cac6e6b44c5d2edbed88eedb882bced645312"
    sha256 cellar: :any_skip_relocation, catalina:       "209089b3554dd9e3351833125bd421645af098882f76da834438377493aa2e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843316a9165314f8505084e0372440f004f27d75a10b1a2c4e734231b32c19ac"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    output = Utils.safe_popen_read(bin/"copilot", "completion", "bash")
    (bash_completion/"copilot").write output

    output = Utils.safe_popen_read(bin/"copilot", "completion", "zsh")
    (zsh_completion/"_copilot").write output

    output = Utils.safe_popen_read(bin/"copilot", "completion", "fish")
    (fish_completion/"copilot.fish").write output
  end

  test do
    begin
      _, stdout, wait_thr = Open3.popen2("AWS_REGION=eu-west-1 #{bin}/copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository.", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("AWS_REGION=eu-west-1 #{bin}/copilot pipeline init 2>&1", 1)
  end
end
