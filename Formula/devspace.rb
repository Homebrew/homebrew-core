class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.9.1",
    :revision => "4e25a2c1beb11ed8988529f4e72c1d096f5e1b90"

  bottle do
    cellar :any_skip_relocation
    sha256 "7abb589e7376c223bd79d9654b3780e66cf13ba3dca11b42ef43b181e812be19" => :catalina
    sha256 "3d835f1703ce95baef75fdfef46cb7eace640276c55b33566ef6615e95f5173f" => :mojave
    sha256 "743c0205b9c63fa3d0d21326115a993eba1bfad6b9f38f8d3adb0856064cfc38" => :high_sierra
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
