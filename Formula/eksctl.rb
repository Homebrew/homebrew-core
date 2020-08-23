class Eksctl < Formula
  desc "The official CLI for Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.26.0",
      revision: "d421724d30b9a045aee025d10b99e40e5f738924"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dc3a1053f3f0ebe026c9b2bd9dca98113a359d460dc6eb200efa6a5ae725f04" => :catalina
    sha256 "ac899a5df75c392d0a5b6daf3984fcd00da9753e844b794c80ccba47cf2575f5" => :mojave
    sha256 "264e49ac81b1cc149404451ffef13e1df293e185ddcf6b3aedc7e63a6434d516" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
