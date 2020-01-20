class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.4.0",
    :revision => "a3da218d08e4ba212488aae5a4ef722a5b3fea76"

  bottle do
    cellar :any_skip_relocation
    sha256 "f90895beeb5655063f004d32a043df82be1e7441d531a35b5a4db6b6e9be7ab9" => :catalina
    sha256 "47cb387192c2c055c70f8a7c479dd01f9dbd0f56b10aa6f23d84d8f18939d3f8" => :mojave
    sha256 "ed2ec8a23755b0d2e8d0b76849b4f9147fc63224fffe74b5155a0354aa48e7a5" => :high_sierra
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
