class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.44.0",
      revision: "93927b30c6ab3889a4d82d1afa7ea1c76ea9efab"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99ee5b37a648defe3ee7c4c10b119627386d8b0ecd78e9bed22c0510589642bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "a70326b4452be652f1a44440cb0700f8bd4add226f97f7275556a01cbac95225"
    sha256 cellar: :any_skip_relocation, catalina:      "748e2e2a5fe52439f7058aa1dfe64bc08a8cc2e6d30c874b80e52e284e194861"
    sha256 cellar: :any_skip_relocation, mojave:        "f20dce536039953bd362549021d83de2320d193e675851552c2da868372eda7e"
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
