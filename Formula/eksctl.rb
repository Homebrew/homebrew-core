class Eksctl < Formula
  desc "The official CLI for Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.25.0",
      revision: "673de795554c4138baeda442268026c2b22c3bd6"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf8a03c796d6f493dc9fe9ba7b7b0808ad3c7ffcd1ddbca1bbaf2cf085bda15f" => :catalina
    sha256 "a9736fefe784bf7b47e69661e008e6a968fd2986047315f07aaf261fd4cf3cbd" => :mojave
    sha256 "5b3f1be5f403c90219ca57de78a06f2776a70536f8315aebd6136600fde6ed86" => :high_sierra
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
