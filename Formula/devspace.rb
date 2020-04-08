class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.11.0",
    :revision => "b9a1e6a541df4b82f3ca9c88ae3698e85f98cc56"

  bottle do
    cellar :any_skip_relocation
    sha256 "c520b585b2fc4bd2cf44857a6572a180ef2a67b60f9638c3d66ab7fb265fcab8" => :catalina
    sha256 "645d0d87a396825e979d251cfc083c5599e2ff9342dd501772b44cf2a3a76285" => :mojave
    sha256 "41e0082d0603f6ba06b974ded636d0bc7172fb788552244354988163b12597d6" => :high_sierra
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
