require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.33.3",
      revision: "037462229d3ac8b60372e1340771a0d776389a3d"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5d722e3a3722a8fe96eea886013221d38e59a2c78cab4693bc968995bba0417"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a39fe3026ce8a6f11519d8bcdd574363ceebd77dc60a93753d96177af0851a70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99c27f1cf8870907d5f5985c7c7d174e3ebaec5ee34673ff910eea557f4b9f3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "11ba94c379996726d44a238fdb66ae2ab76186bc99f619f5c58cf0f2f8897b2e"
    sha256 cellar: :any_skip_relocation, ventura:        "5cb03c8ebeebd6329025b10cc972c4996dc6091a4218bd51ea817c485ba05126"
    sha256 cellar: :any_skip_relocation, monterey:       "b583179013a9e9cb28d061d77dd2d5a58cf15920892081b9f22c76f9404cd1ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77f7a9bc085a08caff07c87e3dc468bd9db8025e0189e3eba83826c04520e3bd"
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
