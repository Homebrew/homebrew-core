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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68b658236370bbe484e46fbabc1a27f3cf2cae2e5802936d152423ae41c2ec77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ef7755fd4ceecd6c9bef45818352011e887971a5a148f0d261a982037b76605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02ff55b9b026ce898254c8ec61d1ab0d325346d9316e14914afd6f5c3e478be7"
    sha256 cellar: :any_skip_relocation, sonoma:         "512143ce8b9553de7d75eef051ebce74a5722731f570f744cb9fa6ed7701f2d2"
    sha256 cellar: :any_skip_relocation, ventura:        "75bb4c7cdab989f5d70de72a61a91dd8ed02185e37ac2f662d08762be6062dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "414ad87e2ac1cf19001c39284298747272f5546a0d9037539a40dad151398bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99398008f79372e4a9d06112fee367abe2951c1506a61a33d265890b8ec4481d"
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
