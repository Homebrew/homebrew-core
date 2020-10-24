class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.2.0",
    revision: "b37fc1fdf6320adebfce14f46e7d261f1e99fc7f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e8d231b2d001327b34407333b87be1179433aadf8746a0b5ff6e2aa6501eee0" => :catalina
    sha256 "cc0e4fd08606b5d55b9dbdd43d25f969b043752de4412200c1761b073829b4fc" => :mojave
    sha256 "e2b35baa2d66a9fa8e8c92b45f2f0093c1a612a2687f570b8bebf60b3c1f3381" => :high_sierra
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
