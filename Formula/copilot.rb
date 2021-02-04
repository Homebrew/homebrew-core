require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.2.0",
      revision: "d5cba31e20be102e47b8ee92bf93ced832337bdb"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "78fa7a1243e788c42e47ee8a41bd6a657a78bbe6feec0351f4ac2cb45ccf2a32"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4e65bb0077dcf34dca1c7bbabdbc1b34b37660f89f3028321fa30ac13e5f94d"
    sha256 cellar: :any_skip_relocation, catalina:      "0430526ab8a2bf8b3944971d1d69f986ca2e3c2c0881bacb18635b01573b17c1"
    sha256 cellar: :any_skip_relocation, mojave:        "d79031b40ca64ab97a9f885b3c9a81f7174f91f1e7896d3b304d3059994a1bc9"
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
