class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.8.0",
    :revision => "a15a4961d57eb4613297a5e99d68906b96106134"

  bottle do
    cellar :any_skip_relocation
    sha256 "31603893f785e2596eba090773db3d98f0696a84263e54f4f88401ac63b540b3" => :catalina
    sha256 "540f46ebdbe70e8eb4d8d3a0e6d3a32d6807955fb179b523231b83f97b305803" => :mojave
    sha256 "a967898ca5f6310fb583aecaed4771715f7d9c951e644b9688da77133c5f5797" => :high_sierra
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
