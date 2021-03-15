require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.4.0",
      revision: "0a7c64328234b51634ee159305bb45df93a1ff18"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35bf8affb16f06e8435a2a1b273627b240c89044186833e16ef3495f983d215e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca81917801301987b7688fb7a9e8b4fec893ee210c4a7465debd2d2bfdd09ea5"
    sha256 cellar: :any_skip_relocation, catalina:      "d525998e5f9af989be701c5b24760c559340d1dd603c3273766c0d31f4080c8f"
    sha256 cellar: :any_skip_relocation, mojave:        "520499adac5166ebd3407372bc0c7221f1303c94518b3d4ce5aa934d80862613"
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
