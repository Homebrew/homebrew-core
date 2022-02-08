require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.15.0",
      revision: "62c9781146ccdc4941d1cf7338833d257af75aac"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2014556ef5173179df9f4cce8636c932d678889c1a2b44a6585ee7a0f7a1b1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "160d17fcafc7ecbdb7797389082650b42a0c2ee5d5b14e31441c43ba69ad4d70"
    sha256 cellar: :any_skip_relocation, monterey:       "270f40126c0b617ee8bfb50972d0f6156985c67e7cebb63fbcd8efb1f55cfc68"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a3c33c25b70c7692ce9337e79eac0367743b6bf93a9754fc8ce32fa842a6124"
    sha256 cellar: :any_skip_relocation, catalina:       "64e0932dc3c98cf02c8e6307cc8247349f954fbde4694e7525b9943a8a799674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b9fe772f52059e4496fc2ee65b906674fd3e82d4d318be3bf70765318cecc5"
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
