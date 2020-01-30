class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.5.0",
    :revision => "b43efe09fd3d2f567fdd5153de64aee0856c3470"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f0297c7e39269aaa8724fb67539915725d80f1557e2ef3f9410f0fd68577d87" => :catalina
    sha256 "b89125759f4fb86e81dce58ab96e57305f20904e4fb38691ebbe73b1f0b35885" => :mojave
    sha256 "1789489900941c4b22bed944a7e4e74e29f0adbf1ac5a6646d0e25f780027c4c" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-trimpath", "-o", bin/"devspace"
    prefix.install_metafiles
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
