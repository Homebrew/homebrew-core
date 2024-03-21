require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.33.2",
      revision: "8da516ae3af52de374b007d86acf6872f8765b25"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12811f6c046f2f2ee6d431e90f46944f083c4ed19d468ee5b11fad97c5c58ae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebdec4d15da57b9cc8ced1fb593156adf61015cf5d4409bc508c7a46b16980dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae7becab7631fcb16cd45fd4bbe5de46c275a46cfb4cf055f12fae4c36d47a19"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0654a8c4c481cf8fbc40c7c8e5f847aa934314616587e0f75c4f39a0e2a69bc"
    sha256 cellar: :any_skip_relocation, ventura:        "431eef7575d05f1973944e6c8e95b2ef0ecee77990bcf0d7ec0fc796d9ec81b4"
    sha256 cellar: :any_skip_relocation, monterey:       "092ed34ca83cecbf7a22a45a64d0b83af5067d93827acbf7c221e71640d38345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9527aa8639e43186b3122ce925d8ed047eff7d4e4a4bae11955a17d582f3c3cf"
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
