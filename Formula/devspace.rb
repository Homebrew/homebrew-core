class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.12.2",
      revision: "e0d27912f257290bebf5c31649cc64c481bdcc5a"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ff05f09a2805c5ac0c36501fc1d93ac1fb9a3b9ddb680dcb7bd932dcf7e2d08"
    sha256 cellar: :any_skip_relocation, big_sur:       "1d0aa547e34b1b685a93fa01fadce677a0a600e1abb4702fa79bf82e2dd7468a"
    sha256 cellar: :any_skip_relocation, catalina:      "e29be8773304ee77cc18a64adc8722eab8a2a830ce195726237d0d9632aaab91"
    sha256 cellar: :any_skip_relocation, mojave:        "d121365d5b22ecd36f8aedc97e072e8939b7d099b2a50a7efd9119c13a92cffe"
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
