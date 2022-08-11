require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.20.0",
      revision: "39a6f80499215df85be7cca149abbec02a40950f"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73b63ce2bae95683ca94bfaad5314bd2e96cd8d62e8ddeb42e69e34011f1bbdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7fa9d1f6f4a303dd82f6573561e829f93e1f26ddbb081629ef7bb288c3f2f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "2953badaa098e88193bef2e1dc02d4aeedb3e17a8f3ad71222d53e0a17f1ceec"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc10c6835fdab7f1ab420ece19a850a989cdb3d0591e5da66fceef2c9ed706e3"
    sha256 cellar: :any_skip_relocation, catalina:       "22f40d412c9afa644537695afadee95fe6fb473322bd5d17fecbed1f77ccd824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c18efd0dafca5d3441f0ccb6f8f7ae804985f9c7fb14464c1de98ae1c058bc3"
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
