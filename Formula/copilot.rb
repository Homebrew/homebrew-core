require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.7.1",
      revision: "c2d143dfe781a865ed823984c88065a92836b4c6"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f086a344b1c2abce9dc5a93ee51055d6d0a6b9ffb94b53be3f3e59138b5e7fc4"
    sha256 cellar: :any_skip_relocation, big_sur:       "81f05e9994016427444518fd086b07621a8cf4d4fd4f6681fa8580ef72868ca2"
    sha256 cellar: :any_skip_relocation, catalina:      "bf32eb5002c48411587dbc41a53d5eb5520eb3e0ce4f280720668bcd818e11cf"
    sha256 cellar: :any_skip_relocation, mojave:        "4fb4ebf2218dfdc77e9abb032bda30fa186299679a7311853232a04919e79e2f"
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
