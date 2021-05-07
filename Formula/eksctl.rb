class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.48.0",
      revision: "0baafc637cea604feb0509bff31432dce4b28e3d"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3c86961a003bc59a322338157eda2f986e8218c6c98342d739cb6994f2f2d02"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6f0d27cada456be7a2d99d59feed54900eda9ae7b25004fde6e4627f147b323"
    sha256 cellar: :any_skip_relocation, catalina:      "de93eacff77a75c91de5b017dabf07eb9a905498be6b24532c9582977f9ca256"
    sha256 cellar: :any_skip_relocation, mojave:        "b956e3439cd13cb104d521a458cbd1c96bfd0e1f2dfb7e1b7b8a0b0913cedd02"
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
