class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.12.0",
    :revision => "467ec71d2074ad26f009879754a34df8c0e4d1aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "a06197407a44abff80327ee5fb636da0d546c270a9efca1fc6754aa3deddc3c3" => :catalina
    sha256 "82b595dc65646051bab0a1de919db2f8430a81dcb543db7e08c94e31376aa29d" => :mojave
    sha256 "ac4a38449814060d07a598407d891c40714452f8257650cdec399bb940f1031d" => :high_sierra
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
