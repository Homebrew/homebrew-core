require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
    tag:      "v0.5.0",
    revision: "05db3dc854ce3f4d946aaf6ab415d53efbd74b83"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df8ad63327a4ef44fcd1d42b5804aff268d697c0e7c1bdb674ea8b97452fcdb4" => :catalina
    sha256 "75943c861fafda5166852e9bc3448c0ff5c011722effa295797dbd11af4b28a8" => :mojave
    sha256 "30bb95e1345233d6ce5404a0733ea35081f533a175abe66c35b0e831a83a7ecc" => :high_sierra
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
