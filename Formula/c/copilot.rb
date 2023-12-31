require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.32.1",
      revision: "72393b8154cccb71f6c7401cb2d4d323e8253c4e"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f4b0c43a8a8d75661dad0902a162a225828f8303535847ba173e9c35e40eeaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a33a779d3f0474a05581b961fab39c518a58ef7cc1acea352cf07cd9b9013d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8d88e9e3bdf71e27767b48d638b74f5627bccbd306350ec8b5f7288d7b1fb69"
    sha256 cellar: :any_skip_relocation, sonoma:         "952bf2f49ccf7569469becbf06db3a55a57f1bb9ba27dff127a20ac59ff9dbe5"
    sha256 cellar: :any_skip_relocation, ventura:        "31f21c74f110ac04da0ae5f0c91a29d98e81664bfe13a163866b37af20d50393"
    sha256 cellar: :any_skip_relocation, monterey:       "866d2dab9caeee16ea0734d314efa0fa6a83193cf56ac88a8bf7b7d5d4f0720b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22cb0f1466e40811a56d739e8e79b0601e0dab54190b15af245e74d2078db16b"
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

    assert_match "Run `copilot app init` to create an application",
      shell_output("AWS_REGION=eu-west-1 #{bin}/copilot pipeline init 2>&1", 1)
  end
end
