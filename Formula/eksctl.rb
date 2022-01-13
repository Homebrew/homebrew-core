class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.79.0",
      revision: "e70880d06dff8b461ab667f58c39765c75adf37d"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de1a25f46baf94486f0ca91d71ddc484913218f38520304b81b16379353d1fa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "416969c7ca6f35161b3d80521864f20614a7424ec3aaf4c27728180bc22bfbab"
    sha256 cellar: :any_skip_relocation, monterey:       "38d973003ce662f3674ff462d32daacfc3e8c827c0eecc6db8d2697fa8059b0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7530dd70f2309ef32c7ef4db0f234c0a90202162aec73d82e2b0ab2460fd489b"
    sha256 cellar: :any_skip_relocation, catalina:       "2832d6831d76e3640fb053a81ffef5522938105bd5323551cf8985338b1a3972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fff379cbe0e25a6585c51ac973da713cc429aaa9e5a0ebe6d10cfd3cc0050c23"
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

    bash_output = Utils.safe_popen_read(bin/"eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"eksctl", "completion", "fish")
    (fish_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
