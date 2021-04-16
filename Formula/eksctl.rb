class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.45.0",
      revision: "8998be02d13f1fabae28ad6e3162c15666dcc75d"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "856886e4837408f21cd7e468e736bf735fd51d870284ae7da845fb7c6b0c3652"
    sha256 cellar: :any_skip_relocation, big_sur:       "055abf711f23aa1945be6831caea77ae6293079d478e4b362dbb32ea901edaf8"
    sha256 cellar: :any_skip_relocation, catalina:      "680cf7d00a6cbc97520d25addba9cb8e4e8423a6dace6a855d7ad33fcc676832"
    sha256 cellar: :any_skip_relocation, mojave:        "54bc131818b27b9c0383fe0bac2a524d45904b633463639ca343a74b6e087357"
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
