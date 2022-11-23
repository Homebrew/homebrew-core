require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.23.0",
      revision: "31385c0140800d2a54da6a9bfc78499f5e1cb90f"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95793797239c248bb3600acb68043c00fd489866f7dae65f3bc2d2c8790fc1bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e359efd61fe5870cb7d7b8108c8017faafd141bef4be9061ce49fdeee06e547b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bfc3afaded8f651d4a61efd16a3effa9fbdd712bc5e1428b0d742d74328f6b7"
    sha256 cellar: :any_skip_relocation, ventura:        "5ea5ec34ab3b84ed0f6673ca9acc6bd398f501113bb0bcc435975cf0d6a5ffd8"
    sha256 cellar: :any_skip_relocation, monterey:       "ae392d178e3df5b404c72cd2ad180acd905a8ef3dcfca22beeec65c244279b80"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcceffddcafbdfbdcfb25e0343e199343b528196d82a2f9305a8344d137943a6"
    sha256 cellar: :any_skip_relocation, catalina:       "941dcb8cc0562c834a4c3d64a4371810432cd5e1f900605f4b287b932bfafe75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8d59d77a52868771f362b86bdf3b88a42f06c1f94f725357eda14db42b35321"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    generate_completions_from_executable(bin/"copilot", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    begin
      _, stdout, wait_thr = Open3.popen2("AWS_REGION=eu-west-1 #{bin}/copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("AWS_REGION=eu-west-1 #{bin}/copilot pipeline init 2>&1", 1)
  end
end
