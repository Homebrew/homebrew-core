class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.73.0",
      revision: "f30d401cc4eaffca1d8616c21a4e7aa84c9c3d4a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9098a185de1946434e9812746cf210c1fb075bd029e4b1d4f0fce217b316d4c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e3e0ff1ce9cd6972213877c1689fc48570c30d8cc252af7d4bb245968fab444"
    sha256 cellar: :any_skip_relocation, monterey:       "64f6adc7c54f0739320bdb877427f791d1c7ba9b537024d127b4b4a2d4490183"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc5d0257c24494c6856f7ab12663a8a159e1aa4344c23381dce6b21761750da5"
    sha256 cellar: :any_skip_relocation, catalina:       "ba354062bf6d6a1b934d58e62de29ce6e34fee37b59c4318232e1e71f9d04264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f46869687f99a07bdcbdbda6376a5c3307acdf263dee102f4c2acfeff304cba"
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

    bash_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "fish")
    (zsh_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
