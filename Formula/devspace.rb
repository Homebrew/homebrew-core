class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.12.3",
    :revision => "0b253245a7c9d9cc7a04aaf9a0ddc69ca9563756"

  bottle do
    cellar :any_skip_relocation
    sha256 "1362e5d27889de1bd0c9d85727839957deb14af41b3a6da0affda84ac100b969" => :catalina
    sha256 "af2e11cc9943f2e60eff0def6b938460f620c3aef7efb46c35f78f832e439470" => :mojave
    sha256 "2566e3b550e68a2dce1ab4be558cd031269dfa457f6d3acde22893937b2590dd" => :high_sierra
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
