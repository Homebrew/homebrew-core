class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.47.0",
      revision: "17cf3795bbf5784bc7a7071f779c6839cc7d6143"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "820e0595b02780b6420f7c45ed2ff36a0897f4419527ce7e4b4529762af9fd3c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea1b6ea8c685a3b1799fab5863ec6a84474aa737bba3646178041eca349b7a83"
    sha256 cellar: :any_skip_relocation, catalina:      "22ad4d78073efedc5396ba87bc2ad31703e2507debc722a06fe9a41e89793457"
    sha256 cellar: :any_skip_relocation, mojave:        "5ebb003c9e2331ffc3051edec1228ff79f093cc36203dbac691eb806e44794b5"
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
