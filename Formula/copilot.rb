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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d7a78162ddb6acb952bbce64e3c4875c1a3776fe9a5c4bbe9be69304340a1a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e2580834b25c816ca7acc7facd37345f12af5c6d0996dd1c6f7f4d2e01bff3b"
    sha256 cellar: :any_skip_relocation, monterey:       "6cb73310404a19aa459f0fed17d8fb6239a5cdc15e065cc2b2633973bdb17ef7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aac7fde4659f31d38bbcc69b444f782752b9352f6156890ee2c123dd1233e75"
    sha256 cellar: :any_skip_relocation, catalina:       "be3c0017ec71d9c114f420dbaebc29abac3c0ff22d80ec6facb34c9123d3f60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dd4413b2329e7a7c32ad86d19ad5770ce2d283c1ba623489b8ff38e72fdf02e"
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
