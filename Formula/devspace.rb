class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.9.1",
    :revision => "4e25a2c1beb11ed8988529f4e72c1d096f5e1b90"

  bottle do
    cellar :any_skip_relocation
    sha256 "51d9f1197eb45dfbef3916e5da3148d03ab02774beccf3ad2fb878f5a764f919" => :catalina
    sha256 "528c8dd8508fdbc03246541dbba40bd6af0a88dc955f23000bf16ba189f81ade" => :mojave
    sha256 "3e1ef04440136709f3426e8273828d4d4fc1d169a792c8760ba38dda6e4f8296" => :high_sierra
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
