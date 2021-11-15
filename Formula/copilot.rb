require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.10.1",
      revision: "0b1d4015dd6f28b6649bbf6752be546527420a37"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2caa2455daf60d7aab24f5854971eb063eb6a4742356f0a5fec6c3d0f0ebff31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8993199dfdef70c96b0bb754f96cbfdc5ac4f8512dc9afc606cfd0b9480c1fb9"
    sha256 cellar: :any_skip_relocation, monterey:       "b2295f3f52cdfe07318ebefc95a085d65951055f4d6f772cf89f4b0995771518"
    sha256 cellar: :any_skip_relocation, big_sur:        "672366ea1b8ab2397a2a6ad25da162492b69d5869dcad2556ba7e0bd4032fbed"
    sha256 cellar: :any_skip_relocation, catalina:       "5219ef7c23e3ba9af9aa39e34797658f08ac777666f0f59d07189e3b781833ae"
    sha256 cellar: :any_skip_relocation, mojave:         "e65079bcbcd01f771c77c18699e9f44a000c8d0bfc64c21b07d4288b80618a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1ad704b8d46786d0d9fed1dafb517d6fadec898ba7e13135167fcaf0c976c72"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/copilot", "completion", "bash")
    (bash_completion/"copilot").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/copilot", "completion", "zsh")
    (zsh_completion/"_copilot").write output
  end

  test do
    begin
      _, stdout, wait_thr = Open3.popen2("#{bin}/copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("#{bin}/copilot pipeline init 2>&1", 1)
  end
end
