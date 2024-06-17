require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.33.4",
      revision: "3858bf08c83b25d11905a9e8e8debcf1fb24ee82"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95f962ace485347b1fedc30c5519376d0a551c24ae1a6e8ee88027328680ed80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d65d611fcec14daa41260cf8ad23f523239607ed33820de878c6a10d915ac23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2a8aea3fdc59025ba9f76dc74e15a8fd747d93fbb40affcc4708787915b42d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec978c3a7a2261692dd71c287809fd4dc20360ef01280fa8adecd2273aee62c4"
    sha256 cellar: :any_skip_relocation, ventura:        "b26c2146ac85f7b7bd1f38284288fb7dd28e321a7d0a7cd701d5bfebc5f02ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "2bb727f19f5f569c8d1a272902d0a510c1b82a7a67b8ff2d4f7b425c3345c440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f48815707a60e497c264d6ad2f715ca4ad7a02d299b7247b2993df270cca3f"
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
