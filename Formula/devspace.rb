class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.3.5",
    :revision => "e16b0e4e8e4997473cf6e7d0296c152c1f4f063b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2c1fc7dadd5943e0af30871b5e712598b59aebe9ae0dc0d040f63300f44e34a" => :catalina
    sha256 "835c62491e12f3b7ba83f6d72566bbe255ef068f11b868cf4946f0b63fbabe0b" => :mojave
    sha256 "ea34a4f5e182dcd7256b0ca9206af1907084639443fc045d48721101a93f4b05" => :high_sierra
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
