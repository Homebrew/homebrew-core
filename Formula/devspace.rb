class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.2.1",
    :revision => "5e9fbc5e0f37aec72a6356f8beec4a27f697dbae"

  bottle do
    cellar :any_skip_relocation
    sha256 "f13dbcd3813bc2938f1f741e832092322dc494407c6900d2d89ae027af4ff01c" => :catalina
    sha256 "80f8cf458d3fecb12adcb04e1594ecbfb10125248a55fd22a0d37ca9840645e1" => :mojave
    sha256 "c5d1f3949542f2c28e407453397385dfe4253a6cb28f5d636bff7dda762b8d56" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/devspace-cloud/devspace"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"devspace"
      prefix.install_metafiles
    end
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
