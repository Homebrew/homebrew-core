class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "42f37960360063a9a277d40d9e1c0b284bc49a12dbf996696551154737d94475"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6956e0e2fd50ea21db1b36dc6a23a1577c302f659b4b8d1d48d08b0c74df87a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13faf4886169d8f186deaf7635b8c970f23155a7cc871f1b002ff7cd6c4c3cad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "612ed50072ab9efa44768a26c50204ae34f6239eaebf4943420f3974346e5099"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6386f436762921c82276a71a96f3cb039c19feb6686cd1f0425ead33221ad52f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6bd3082d39efbe86dda980e542f93186871646ec9ac23b951f7683d3422f6c9"
    sha256 cellar: :any_skip_relocation, ventura:       "1ec11fa87d97cc7efe7093979126094c6f67ca0f4834df821d60431a2d92e91a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c72c7b0fdb9e03d19111e4eb6b77e4146779cd18a42a2820666fd5f73e6c4d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbed548a000b6f038d80263542e7f794a6ceaae95ecfd3c2cc321bcf9d89d5bf"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV.deparallelize
    system "make", "VERSION=#{version}"
    bin.install "bin/local/copilot"
    generate_completions_from_executable(bin/"copilot", "completion")
  end

  test do
    ENV["AWS_REGION"] = ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    ENV["AWS_ACCESS_KEY_ID"] = "eu-west-1"
    begin
      _, stdout, wait_thr = Open3.popen2("#{bin}/copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    output = shell_output("#{bin}/copilot pipeline init 2>&1", 1)
    assert_match "Run `copilot app init` to create an application", output
  end
end
