require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.8.1",
      revision: "087823e34e545e8f22c0c341b8695b596a2be256"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b22a6dd122b7481dc64d64db04f357c54c3727307482a455a3d2d52d7cedd0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "188818ced6163f2c13eb1f837045437ec11748663592801a86d5b931408ec80b"
    sha256 cellar: :any_skip_relocation, catalina:      "f6ffaed33b920f50e6a722630cafe1518a833a1956b1a2ef1bfe884963e0bfbd"
    sha256 cellar: :any_skip_relocation, mojave:        "a50a319dd0b4b18fcb3606d6960fa672f12352a727a2b83fa938992f0d6dd1bc"
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
