require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.26.0",
      revision: "3c212fb45cf46ea497f4bb31955ac1c2e183625a"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e9ef48f73f2e862e6f82798876ae5e3ffdea88b09fb65b4dbcde49e7c090e1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7892b5c994be4ae0d0d08e7e674e22293fbfb4cfc680fd39212aa050b4908331"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "737472f9a96867214bd0054db2f605edc72edc2199375dd72a4802a8acfd79ff"
    sha256 cellar: :any_skip_relocation, ventura:        "ec6c318f847f2ac1501fdc695586ace7358d4ae976d31ded6c51a281e541df22"
    sha256 cellar: :any_skip_relocation, monterey:       "09b324a0e6f700799630fe24d7754fd24815cb5c1401615f795c3b8cd9ed02a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5007f1e8e2e33d41135dc7d5b199470ede227e9f12d76d1bd3bf973f28727850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27fb07d18848a8a806e00eb7fbeae1c376475e53de7b0393f166e4e40b07813f"
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
