class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.43.0",
      revision: "2563b211304efcdbf244ab0cab4bf95f3458e3c5"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "732a1192bf8f91d696040d4e77f13feb442d2984edf3e023886bd488e64f9e22"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2d97b1611c54a08609669190af885bc5219e4b092f2a2691fd82d7f4ba44da0"
    sha256 cellar: :any_skip_relocation, catalina:      "71f7ae880cae6286e6ab3cf9f7d0107b70c28dc74c2ffc742debf90eaada8322"
    sha256 cellar: :any_skip_relocation, mojave:        "e43b169001f6b42e330e71d157b97b37457c17fa50257edc5c1b82a4af86350d"
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
