class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.5.4",
    :revision => "c38be7475ae49b0eb368922fe8d2fdb8fc1af8e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7b6d75f82a82e3f63d2e442643b70efe0bb76927637c4091ffa79a238db28ce" => :catalina
    sha256 "e2c1fb22587aa0decd28047288bc7300474cf3d68d7a55cd8ec2cc19d94a3619" => :mojave
    sha256 "8234d99c202f9bc55e77af011dbfcd7331e237409e2d958ac485e6764a8240d9" => :high_sierra
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
