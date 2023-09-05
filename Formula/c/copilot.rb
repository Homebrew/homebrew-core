require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.30.1",
      revision: "e61b1aa12998ccd70c7dc7db5bbdbf63eb853eb5"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2295270a8d9e627381bce24ea6cb24d06cd56e24105b33e50dd670cda0e67865"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5c735993c9396f9b40f5798a7d8651137f041b6c3bc08ccc6c69e6144d0e0a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a43ca3687f4b298d1cd0bafc6653f1310ac1deb81cfbf533df55fdb914658d87"
    sha256 cellar: :any_skip_relocation, ventura:        "b0cf67a0a3585d65140f6e57bb93cee7d9b9503a1eea097841fec6b7526ae408"
    sha256 cellar: :any_skip_relocation, monterey:       "6c46855bee6645a374c199e0352e3b01aa87c3028be834f598728c427efc8181"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8bdce97b0adac51ca5afe386120da2c5b0310c921fbd2dec1e6a81cf35af230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acf4ccce4a014461bcb34c97693970fa0cee8f4c5ea8beed5f18a82cb97ec39f"
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
