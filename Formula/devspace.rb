class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.6.1",
    :revision => "79c0e28f426fdfa0f2f486dd69ba5e9ad53f7caa"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a893d913af8dfb0336d8fab40bb0bee2b3291dfa2cf291c373ff59627362973" => :catalina
    sha256 "9243e34ac701246cfdf78c75b8262e06bbf2d351e22f4d5f3daae4846c53a4e3" => :mojave
    sha256 "14b51e22d3129bc722281314464006dd4ed03eb4903114b735be4eb226849e57" => :high_sierra
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
