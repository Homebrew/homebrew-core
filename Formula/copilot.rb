require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://github.com/aws/copilot-cli/wiki"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.7.0",
      revision: "35958604cb68d0d7ccfd1dd085c5e485caf7cad5"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83760d898e65adb50d9bd1edf81a4011442cc20acf2b91df8bed712d7d1e14ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "bfb23fd83839d3d7619aa7c607050b0e92d557c343753823b87016e2e9130949"
    sha256 cellar: :any_skip_relocation, catalina:      "7e10f8c1c80252e0116a1ddd8d07de86d824b0138f60d5bbbc37516047930319"
    sha256 cellar: :any_skip_relocation, mojave:        "974e434a50cdead56470d6d129e15baa545691fff6e3b6e51fd8a19b23b51bdd"
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
