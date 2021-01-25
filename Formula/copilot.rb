require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.1.0",
      revision: "79c165450bb68856f565fd874e21e191e9a873b6"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "128866c9e4a1dce2ac3d49f87dc026bbddefa9f9ee260fa5a39b208a90ebf4fb" => :big_sur
    sha256 "664cf1610f1ac05932f66f3913deb9a843d5bf88a9a64f92994b64e358035f80" => :arm64_big_sur
    sha256 "6cf8a375a9f0bf5b9bf8edb25f0a3f30b02fa6731820e4fa3ece2cccb9114150" => :catalina
    sha256 "70d65858a244d54eda5e2860ef2183f82c154346258cccac9416859ba56214cf" => :mojave
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
