class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.4.0",
    revision: "6312e8ce61f5b4ccd97b855741fa9d18e0cfe592"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/devspace-cloud/devspace/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "43daaa490f37b96c2b8fc357a33a4dbce033d5928b499ccb31fcc238c82a5b1c" => :big_sur
    sha256 "b6e6d0d7b5e9786efd663c29ae4579a45496ec23c9ed0b7aad149ed9e88085b2" => :catalina
    sha256 "e595cecc90c03f6ca23dfba1f6ee4f5d77682653b822301c124cf97321343a75" => :mojave
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-ldflags",
    "-s -w -X main.commitHash=#{stable.specs[:revision]} -X main.version=#{stable.specs[:tag]}", *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
