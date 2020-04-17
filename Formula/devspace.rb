class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.12.1",
    :revision => "fb69040c79332b26faec974e52e3dce6eae3f09f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f55cedd1e80bcc9043ebbab1dfa0c4f51fb28f4075b61b68a67615f3e472bc3f" => :catalina
    sha256 "691edf4aa2e4cac6e9ab10d91514e5d2129e3bd28e017429cb56d55cb5d65407" => :mojave
    sha256 "8810b358d96cb5775f3a7697bec98b58eaa3a4d35f769f83e93bc58e7e6a202a" => :high_sierra
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
