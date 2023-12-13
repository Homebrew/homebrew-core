require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.32.1",
      revision: "72393b8154cccb71f6c7401cb2d4d323e8253c4e"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a77e50ee77fb143212c0770dbfe1d0848e5b8df0b2dd647e6f82f5943744ca0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97661574b99442e9d7aea35ae9094d099c3e8338d343db3920b39e3ceff6c24d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fac3a37f30d1537ccb20cc3d213460b019fe6a7b31ccbbf012fddf1478a1b8c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e05172c35cac6b16b0e29720945af1d384cc54e8dd174f27c5e27e6fa4d785f8"
    sha256 cellar: :any_skip_relocation, ventura:        "3dddaf4c16bbe6e6d8c5b547f2a9902f8ce4965a63a7bb801a2024b5a233f09c"
    sha256 cellar: :any_skip_relocation, monterey:       "8275bf000d48c85573351dcc85a8edc643f723fc97739b7e082a0f8fbd6f5af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f0e45551d04a9074755e272e86fee4d673cbdf8d4d2b9183471bb765bc1b7b"
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
