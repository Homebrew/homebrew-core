require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.28.0",
      revision: "88a24783b5c7d1d4f056b3098e37cb7efd7b4381"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d1362e012b7eaa7598621914c603264f80323d288297e527d731e2c71c03024"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3c0a65afca721c58751b62e93da8d47b9c02c9046ef05bec0a58949ba1fed53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e5e8685fe8a6ccc56238d9cd2808244d1a61b34e4852130852206ae6792ba6a"
    sha256 cellar: :any_skip_relocation, ventura:        "99e82efd0d690ae92e3693d81b94179f99dd00cc27c4e3550f8d0e2af4ff996f"
    sha256 cellar: :any_skip_relocation, monterey:       "549b33ac8d2e7fa958ced602d75d268d85928aa305315248e834dbb625ae2722"
    sha256 cellar: :any_skip_relocation, big_sur:        "e27d78745012d02dd53a5892b5452976c1f6add144a9ce6f5a0454368202e6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e57def6288d53535544a1b160cabd1b80fbe81e579cb3e99abdee0c24e51df25"
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
