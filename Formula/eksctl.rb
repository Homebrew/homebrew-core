class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.38.0",
      revision: "312d801391490233ea26c907106f04ffaeabdf11"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9e0de3ae1432c82cf15c2fcb7271be9b41448d45c664ef618b837eea9cd6928"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f6cacd789fc449ae526e6d1b891169da85d848e8a55b86f3cc69b0da7ea7c16"
    sha256 cellar: :any_skip_relocation, catalina:      "1c2aa2658bad4b5188c292a834a26f62d3901e6df20550df767f07adf33e35e6"
    sha256 cellar: :any_skip_relocation, mojave:        "98c8f11b026247c07cb58f0f5ab35ef822c0cca4ca4534f395f94e07966cdd55"
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
