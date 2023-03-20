require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.26.0",
      revision: "3c212fb45cf46ea497f4bb31955ac1c2e183625a"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbbac14e32d28e44cbc5eb2c5ddc3b53ba9fefe985550952db4769195c2c77b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95708df36122677841d21342491b2a1be3f9521aab7d45b17bc197d5c02551e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b1845cb77b86676239d58082009b3b2fe36b06542997e3872582710d9adb043"
    sha256 cellar: :any_skip_relocation, ventura:        "95efafcb8bebbe23bcb2f8dd64d7bc5d76d0062ecf43a9cb86c46f3d7e3356b2"
    sha256 cellar: :any_skip_relocation, monterey:       "2b03e43b028e6c8a4ea8c69383fb8b2bd1da5e170c1f2646f04491d181c42fec"
    sha256 cellar: :any_skip_relocation, big_sur:        "66fd48dd70738c7bacba9cfec0c09da052d49faa903ed0c8066f32c5e4367b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dc508cb5be5182e3da8500b3d6f2ec58532fc3b28d0815ce2f1b62bbd208377"
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
