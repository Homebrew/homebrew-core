class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.8.4",
      revision: "a5cf9b686ab1b9bf295d8e9316130fbccff82220"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "72dd11325097e4b2355ee739f8bdfe2b90359f0290fb39d62b2114339c9c6923"
    sha256 cellar: :any_skip_relocation, catalina: "0132a3bdb9af51ced32e3026c97ff183568200e60e2a6a0b70b2a55052362ecf"
    sha256 cellar: :any_skip_relocation, mojave:   "8e936fb2426034649d4ddff785c388a3c41d43731f86d2ceed933b9833ff3fb6"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
