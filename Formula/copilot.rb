require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.22.1",
      revision: "ba55334906364ecdef5b4044f00f5b642d24389e"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8756e7c5431cf10270b1a5f88ae3c412c695b305f63565aa735a2c51a8a9194d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10052744bd1bcc74b7389c7db93de3686f81be153c6eed0edcff82d13ab8380b"
    sha256 cellar: :any_skip_relocation, monterey:       "1f1fd2040fd97f5c1212a9ef3611bd8e3aa8424a31920c31328b79d6f37369f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "23f9f3201c638eba7211f138e9c5a6b1fab884f2e759217b13cc1adaccb239dd"
    sha256 cellar: :any_skip_relocation, catalina:       "4011202e6d4f3c05ef2be43d8de846153233bdd320bdb27922a4bd3d3a6b048c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93d96057dc8089195a4e7eb73ddfca52eed564246a3c7fc84f4d1bca9633a272"
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
