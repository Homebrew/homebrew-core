class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.7.0",
    :revision => "de5f1939087e1963a113ce1b110b08f9143ed060"

  bottle do
    cellar :any_skip_relocation
    sha256 "bca2d90c1c8e122359df7eca48681d1d03100886add36dd0e1557f8848553564" => :catalina
    sha256 "9f2d686c1a77f23d207aca2794543e8a0b20a2f09badb453198d93f4f53ab5be" => :mojave
    sha256 "2185b1bf0b07179d12e256f6e93a087d242e58fdb6a197d94509ee2256a17cc6" => :high_sierra
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
