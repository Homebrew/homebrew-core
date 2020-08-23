require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
    tag:      "v0.3.0",
    revision: "27ecf7cc57ded2469a52b35f19afd4454e950eca"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36cc612d7c413f7bdae601571a41f6b13fe0599398f1efb2943ea2a6de398ee9" => :catalina
    sha256 "5484a0088f79a59e612341ef3a60a7f24eb49b728cfe10bd8060e5e4b51e96c8" => :mojave
    sha256 "f715ed75de1161a5bcd2e50fe2fb52486cc6aa6ebdbf036a2e38c6acee18e0b0" => :high_sierra
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

    assert_match "list environments for application : MissingRegion: could not find region",
      shell_output("#{bin}/copilot pipeline init 2>&1", 1)
  end
end
