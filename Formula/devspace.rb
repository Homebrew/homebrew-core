class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.3.4",
    :revision => "434896a7030b7ea030064e6d5f7599022db50f83"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f0462b744b913f8a5db2ff69986c85c2ebf079bef14ffe4202aacc4783367c9" => :catalina
    sha256 "7faa351d222d9fdbe0786cc39f806a8eac23c9b0577d59b6f1a502367533f790" => :mojave
    sha256 "a66ff6fba14deb0636fcf7c150f6ef02011ca78620907c9f1c0925791e477c94" => :high_sierra
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
