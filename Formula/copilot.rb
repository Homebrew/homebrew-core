require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
    tag:      "v0.7.0",
    revision: "36f93377216f402f725eea1ed0f748617838ca3d"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "32a631e3b7a02b5a8546a8ce11625e4c83068d6d8aa83dba09acc5b5a02693d7" => :big_sur
    sha256 "0cc0be4fdf50abf67366e431b458d352cad923823bb3665d75d5f8c1af764592" => :catalina
    sha256 "724c2d3de7fd5c02aede3f7ccfff82f44ecaf3a49c6aa80060f184e6215e85e8" => :mojave
    sha256 "d46aff448be9556f34ba4ce34162751b2a0d05ddaaf22ca8240fccb7256ba898" => :high_sierra
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
