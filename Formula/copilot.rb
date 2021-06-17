require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.8.0",
      revision: "a486bacac9a7c5ffe82df29f16c80946ba815e4a"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0ad40ad41dc0bf89605cf547971b2e2bab88b81fd54306dfff8460d289e23408"
    sha256 cellar: :any_skip_relocation, big_sur:       "352bc5b9c321cca16909f2d7dcb562d742d85d75c9fd6fb62a973aa879244c50"
    sha256 cellar: :any_skip_relocation, catalina:      "37d9726fd7586e9dd390bdac453f1a1a7fd79c9388b01a892f7afe7653fae873"
    sha256 cellar: :any_skip_relocation, mojave:        "3bbc65ac0ce5919a0cdbbf7ef20d31acf0c7728feae032b06e5b50f7cf96d7dd"
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
