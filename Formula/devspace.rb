class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.11.0",
      revision: "37f0042f2204233072c6d063219f8362509387b7"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e5d8b2947c20111f0865a5769965946d1e979418e018d179e6931f3d6c22bf1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec6ab21612f2db940a4515200d01d6c00359983c1b42b60eb4e795a85e955cff"
    sha256 cellar: :any_skip_relocation, catalina:      "849be97efbe798e55e627edf5329a932bf96d2f02f9374673047016060978f5d"
    sha256 cellar: :any_skip_relocation, mojave:        "a620ae25b1821506cca4061bacb183156c594a800796042883a7d5192fe5e1b4"
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
