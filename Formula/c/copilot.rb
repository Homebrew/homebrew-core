require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.29.1",
      revision: "123b8afbae354008a87b786723da002ff84303e1"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce761e3913e031b870fc6d0cdf12fe8b6d90a7f09c742185fc3d9e5269cc1048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a04b0bfe30ca1282739d273280d451438a6456215637b9e6be85489af6fe450"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f327284a7f2e0716c2ce1bd3ff0c2cc2be7a831f5c1637efbd49abea4803482b"
    sha256 cellar: :any_skip_relocation, ventura:        "eb345b2789e458752ce7031415608a87fe744b13873f8a0cb6508f674c9e78ed"
    sha256 cellar: :any_skip_relocation, monterey:       "7e2bf36f6dfde40c334f61e7a3f6d63ccd989876f4495bf70a9e50e042afa008"
    sha256 cellar: :any_skip_relocation, big_sur:        "3562af38b2243541d0a1aecedc2e81ebb938a994e79b18be3271f503fc4ac882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a39c85f7f0f58a483e38e7ac8d47f78c7500f1bb24fc784708d6fe9cd46a1890"
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
