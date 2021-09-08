require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.10.1",
      revision: "0b1d4015dd6f28b6649bbf6752be546527420a37"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e56270709b7ea332a383c8d9007c06c3bd4132dc27cfcca9a6fb19bddaad668"
    sha256 cellar: :any_skip_relocation, big_sur:       "df9370184c1359973a49ebfdea08cf807ee45662621e9c5bb0250591febd9564"
    sha256 cellar: :any_skip_relocation, catalina:      "7cf50124c7064ec1659cd25541be9edca29c550b5ad81b156975ba94d95a8e18"
    sha256 cellar: :any_skip_relocation, mojave:        "c346d42775ec3ae17223d4311b3a2f1cfcbcc5b464489ca5aa80eb489a9900dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5367e4c532ef9cc254771f78a53c8475c35084da6df240f5fdda48c9b0b8c6"
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
    begin
      _, stdout, wait_thr = Open3.popen2("#{bin}/copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("#{bin}/copilot pipeline init 2>&1", 1)
  end
end
