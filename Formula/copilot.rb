require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
    tag:      "v0.6.0",
    revision: "8c9bf0105982d1f42d43f4df8604c0fbd455208a"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e0046baee40ee74f3533e95e462e7d78ad1906e4a41b949e63414d932918049" => :catalina
    sha256 "74bf05beeef609cb8e62372c102b5d763ee1b00dbe3e5ca52b60fddbf67670de" => :mojave
    sha256 "dbe2fda5881f9c8ec41580d63aff53930c78e86fd52e03f4d244322cb224679d" => :high_sierra
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
