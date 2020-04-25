class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.12.2",
    :revision => "c7aab66f97594c74b2d141af0a6bd3d26749ee5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "6da69af37a6d439661b76e7902cde23e923da605befb1bce3d12dc62701c46bf" => :catalina
    sha256 "9001cb40a65eb64daf71f29bbeb9eb725cbda5f0128909c24ac8ca44f79411c5" => :mojave
    sha256 "6155f029524e1bcc9b25f38522261cf5583588baa12be4ee97cf67aaa1637446" => :high_sierra
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
