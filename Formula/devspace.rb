class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.12.5",
    :revision => "44f8389c668cfdef60757214a8ce2a0fe5465dcc"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f6d6854dd9fc45eb2e94eadd49f33240603b9cca5a15c08c281e2dcaa95e00b" => :catalina
    sha256 "e1abe56e9755a53fadc0dbb554bb7d55e1d8d192444267547c1c12f522c0768e" => :mojave
    sha256 "9f5804770006d945ac2b3116744f695c0ce98daf628bbbfc32ec46ee4dcd6f33" => :high_sierra
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
