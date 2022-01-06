require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.13.0",
      revision: "cdbd8f904790514c056f6745f8212fb9f8a4179f"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d45375c1edeb398a9e44c6974a1d13ef804cf661e406c646279863b00657382"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eae09415d5dcf0ea922aa1dcf69e30e6e5d9f065082aeef2d9dc1a23e17f94b"
    sha256 cellar: :any_skip_relocation, monterey:       "c22dde2c56748828f962902701f2027458ddfb909d775e4361460d49402885d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "7df9163d5a52884497f510852719d8e86db16349c9f0559d1437fa6583aeceb5"
    sha256 cellar: :any_skip_relocation, catalina:       "b23d12b311ab01011702bf13e78e001ef58e880f014b834742518fc38315a965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ada1dd76149c43180c2831008a0b080a4ae8b83b96c6d65fb9d8d5bfcff080b7"
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
