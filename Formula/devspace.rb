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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "050103873ed0883f751ecfd29e7b72e1f29b7304f0ede7f69d4206289c534325"
    sha256 cellar: :any_skip_relocation, big_sur:       "9d791c564bab4232f27487bb1e10543bd5090763847660c66cb0c0c06f43e957"
    sha256 cellar: :any_skip_relocation, catalina:      "fa979d3d63d940f32a93e602684158fadab8287af6e2d8de64db554935ea91de"
    sha256 cellar: :any_skip_relocation, mojave:        "ea7aa4470ccf5c6d4953cadfe8fc2596eda0ca9d682733c2468e7dfc4846d179"
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
