require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.8.2",
      revision: "3d9721285d30bfabeca677053ccf8daba5133200"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00bb3d3cefc2e9f28a6ccc0e8edf7f4eede495b9bfbd14291ef77a23545af5c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "776ebf226370b5fa82ccfa98e635477c34c8e1efaac5c55f160edb41ccae05cd"
    sha256 cellar: :any_skip_relocation, catalina:      "e093da32cdbd3e12fa39d85de968877b1aa8f8bd53fd1674931262f93447fc05"
    sha256 cellar: :any_skip_relocation, mojave:        "5b053e65f70e6bd8b7871bee753948e0772ba27197caab88d504e787079d1a46"
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
