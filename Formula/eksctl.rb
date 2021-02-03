class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.37.0",
      revision: "6cc18c563b313f647276defcf70cfa14c7fa42ae"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "78d6db8b87c892f61c94a1f9fad8adc65d9a6ae22411bc6ef895be9a7671592d"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f4a6b5c0190bdc3b5c11b71ac966e9d1ab26ae1b6e6de780590eca857e1b3b3"
    sha256 cellar: :any_skip_relocation, catalina:      "1e0a4684c9a1c4e49e17afcd3d1f28639db72e84538b583144b161ec64c3279b"
    sha256 cellar: :any_skip_relocation, mojave:        "f047da8c815658c26746d86904adffa97a5513e82a24be881239f8be7881075d"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
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

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
