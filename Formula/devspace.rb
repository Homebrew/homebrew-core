class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.2.0",
    revision: "b37fc1fdf6320adebfce14f46e7d261f1e99fc7f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "dce8c9bd8debb6f17e15feb3e98fbff3bb6ee7d122ac93c1e3b547f7ee1572a3" => :catalina
    sha256 "642c3d1ace2847edcaea799d2861c38afbc2b05108416a22862c2f4fa859b65b" => :mojave
    sha256 "1e5334561395f712d107c73d7cbfd14f5f23f03dd4d6525332830d5baa5e32a6" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-ldflags",
    "-s -w -X main.commitHash=#{stable.specs[:revision]} -X main.version=#{stable.specs[:tag]}", *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
