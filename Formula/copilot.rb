require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.13.0",
      revision: "cdbd8f904790514c056f6745f8212fb9f8a4179f"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70e5e3bf4cf0a7442203d9bfe4e2bfc20d6c3a1c531b0a918ca297d438a8d153"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4560e82379e7974a9adef2b4d5f099832173fdb1f3723fdfef503f8a5b3066ac"
    sha256 cellar: :any_skip_relocation, monterey:       "cc2fe400f8753cb686e3ce44e36d295d5c71188f8c43a9fa9ea92fdb1737e824"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cd6349a40f556d22160773d80e1a521b8be70a72f728fcbaaff9d09bd4e25b7"
    sha256 cellar: :any_skip_relocation, catalina:       "c8dbb1307021b03b9f72cdc75109a162633d5e58b4e6fc8491968b5348ad5fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9167fb1843d6331555af256f28d10413f393b153bf9c671f4ed9bbde265e451b"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    output = Utils.safe_popen_read(bin/"copilot", "completion", "bash")
    (bash_completion/"copilot").write output

    output = Utils.safe_popen_read(bin/"copilot", "completion", "zsh")
    (zsh_completion/"_copilot").write output

    output = Utils.safe_popen_read(bin/"copilot", "completion", "fish")
    (fish_completion/"copilot.fish").write output
  end

  test do
    begin
      _, stdout, wait_thr = Open3.popen2("AWS_REGION=eu-west-1 #{bin}/copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository.", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("AWS_REGION=eu-west-1 #{bin}/copilot pipeline init 2>&1", 1)
  end
end
