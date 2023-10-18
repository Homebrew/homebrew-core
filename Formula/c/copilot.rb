require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.31.0",
      revision: "b9acdb8655411597b65bff9afaea2baeeeb0b6e5"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83dbfa2d003fbe30682c4846039b36c15b89db18513c16e352872870654030d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e48c20bca7949472dc56ad16a9545f411e3b20af5b45abcdaac13333670f9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fd60e655bc0c1233db4afcdbb1d8361fbfb47caf9ce153e02b289fc7195ae4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "04db87ba87b3dd0942fddb5112a6cb836189a8e5d0666b8e42b9609228c662c8"
    sha256 cellar: :any_skip_relocation, ventura:        "7676dbc5ffe9766fb0d0b1ba51168e93da1e1727954426752b2a30caa8ae32c9"
    sha256 cellar: :any_skip_relocation, monterey:       "99fb5e3fbb7511f1483774ac4c4a3d99efe6b08f0d6c342b02fbddd45ca65266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c23d7d412991be7ff17ca7c4b719c742f9dbdb1340d7dd79c027e15465491415"
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
