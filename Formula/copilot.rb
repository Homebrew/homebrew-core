require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.16.0",
      revision: "5002f1123ca01b81d71f6aaab078f8cebb44916e"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9b5ccaf69ca9665ad76f0854957d66e6881f81c94356345d913d3ff12a13505"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8575679877b0a41e85562da33eef6650fa4be5273d281fcd1ffc6f9841a95475"
    sha256 cellar: :any_skip_relocation, monterey:       "665ac8b33882cd0eb91afa007bf47dca9f0f0a60b0db5c64f21f253baf0d827e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0d715a2ce59f3ce53fbba8a1283aa26ab3af1a19ef885d35920a77062274ced"
    sha256 cellar: :any_skip_relocation, catalina:       "81d47d6a6704b68a455a2dfa464ce1e00ca15df6e7300370745a45f393e4067e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e50c755638ae7f1034c5f06b002af083105b519ebdfecae67b11cd489fa86b23"
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
