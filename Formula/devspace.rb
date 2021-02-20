class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.8.0",
      revision: "9bc1d9c65bbcbf4f48b9869e83e090b5841af79c"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d2f3ad4454cb6bd687ce9b4a553022d2c9fb6fc3e6466edc5f79b6e88af8f980"
    sha256 cellar: :any_skip_relocation, catalina: "87c3c00bafd05ff29df4011d4e9667c0e9a3b2a96198edef19b01b0b3a25830c"
    sha256 cellar: :any_skip_relocation, mojave:   "16236439f153e2e8dfb6534a4d8c198c1d7fd38427a5d64aa6a144ab6b4a5080"
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
