require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.25.0",
      revision: "ba44a7ebf4c879a97c3f1ce2ff028bd6357f7893"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac9a2ecb2f35b675deb5b84f668e8e0efabcabca3094d8e24da07dccc17b7dba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "128b8021daae6f94aad1c71b99140af4ca957dcfdb21add1b654fe6d9e574e8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f325a594a87c856522e5cc9d1e7b7660ade49e9b01dfea968c907e7a72357ec0"
    sha256 cellar: :any_skip_relocation, ventura:        "0ed2ed0d8160a089ae407aa36fea6c42197482e0e3cb0bda014cd48c4da3cd94"
    sha256 cellar: :any_skip_relocation, monterey:       "1acd4219a20140302689eb3a8f0038acd4a55f3366a57bb218040f446cdd65b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d98f0c2747ce7050f09dbab368480ca9be170d7a3a8acad5d07c6abe0a8996e8"
    sha256 cellar: :any_skip_relocation, catalina:       "17be331d92f30114f9f601c85ba8288c10552ebf324b0602a45e1556ddedbf49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63be0a8488685722cf25a0b241b8f40235a184dcbc264226721b66531bff8388"
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
