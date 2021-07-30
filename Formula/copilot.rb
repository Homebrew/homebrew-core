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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a8a77f6675386a39d8ef3982cdb9a077880c0b219f8efed77ac287e366ab48d"
    sha256 cellar: :any_skip_relocation, big_sur:       "8fa1ef6746119c158d9b9430064b8df1a6dd6db392599af580493bf1ee78b60b"
    sha256 cellar: :any_skip_relocation, catalina:      "71482ff6bd0974722b6d8794e6625539147a90e1de26fd7d153f584bf871ee30"
    sha256 cellar: :any_skip_relocation, mojave:        "8506fd1fdd7d388fd062ed5788eac856906583531ac9f9ebe1b96d4a89640216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c43427dac53d226a5ae3dd1a6d331e0a4d44a5489b83208106ad5dd63fb64fe4"
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
