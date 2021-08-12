require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.9.0",
      revision: "8fb57aca1cd7a355bbdf1b8a5c5fc590b40649f5"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e75c046502c8ae620c37d78b411beb7e3cd1bd7401c6905cb5186f4cb3618a61"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b1392067f9fede2c1965f0440e387df081081a16d53309b9861cf79dd69c540"
    sha256 cellar: :any_skip_relocation, catalina:      "9d951c7078ca3db1b5dee61520f7e2a136060e969aaab9b71a431b7ab1af1afa"
    sha256 cellar: :any_skip_relocation, mojave:        "775b92eaacf3b8fc4ca33c7d00e6b6e8acb1dd7f23f7dd0efb187b8609eb79f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41a815f9065819301066183767c1c9f720a1432d82b7fc3471223eb48f4d8030"
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
