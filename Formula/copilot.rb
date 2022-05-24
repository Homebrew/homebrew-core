require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.18.1",
      revision: "61a05a60ee990865a1160f5c2e0dcc3575adb596"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b7f15bf255606a4dc9634a959b69ce60dc6a56874562cf1ab57af61c41322e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ab233d03720eed76ebf9c5316dfed158276646743562155a888ba4f4708ebef"
    sha256 cellar: :any_skip_relocation, monterey:       "e5929358e8c411658645b32c4dcbece7290af857506c37fda9ffd10d2da058e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ca17274486d808ebf728c9735133e368fc382649c16f60c508d85a14c6763bf"
    sha256 cellar: :any_skip_relocation, catalina:       "19d501fff65b1ec5b7984574e60148545e8db6ac2cf5c94f2f5744b6d7efa25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eec1aa92f0b1412572eca73c5d3bb48ce652e9a49a41928bf5f586b68a37764"
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
