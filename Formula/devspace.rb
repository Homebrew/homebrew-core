class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.0.2",
    revision: "703926cee72799ca29226adacfb78daf7fc75a56"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5223805a48a52481ced6de2ac1e08761f9805735845ce2b185c00ac304e70d94" => :catalina
    sha256 "9afa68426c97cfd1f992560b8250e4bf15f70d1608bcc871bcb43bb817009e8f" => :mojave
    sha256 "286c7f5e0685e9f347787a13e94e1402addedeb072e056e3762417b9b168653e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
