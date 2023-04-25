require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.27.0",
      revision: "e1f8f53a444e4e1bf74f16805ea844afd00ae54b"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d2d403feb5f2e797df2fd81abcb6015d3e5a7df18cbeeb20dfda3c2e4f5a0b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "522d31042eed5f6c69b1668d02d3befb75bbb8f5a6b43dd6ed68e98632943fc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c21ed49b22fb7e198eead215570ff31ad421bdded026587ce3310badcf4ae77f"
    sha256 cellar: :any_skip_relocation, ventura:        "c7adaf88af5c8d33ec4544d9bf2d96da6faa7c5332f6a15fa2ff9933ca7d36c3"
    sha256 cellar: :any_skip_relocation, monterey:       "d08fbf0c0894770c577818315146a21cc44d7cbe50a95de5938cb6cfb8967cc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "924afa7179d814a49bdfa748b088e600baa2e3e6d64bc7d69669c720f7cf742c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4326ff86fc22cbddf5e3083fb8f2e51a8a5ebffe61e147bce1ca2e1bd2c95bee"
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
