class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.14.0",
      revision: "b814db5ba766d7c43077ee44f073119b41848e6a"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf200c396b04b597e80af2feddd38c78563e57b15648d4be08e5b97ec13a6e6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "864c57af56915bc4455a3683d385a3cec78cb4e7ed39f9fc114472ddf24cfd8d"
    sha256 cellar: :any_skip_relocation, catalina:      "d5ada4e7e3539d07ba935aa28208bd03e03afbde24f9511c4b3685c2eab788fd"
    sha256 cellar: :any_skip_relocation, mojave:        "936e189eb98a6dceff3f11670fc834f18e3503ee9fbe8a40cd801d50522be594"
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
