class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.90.0",
      revision: "08de3f8af239b0882bc8e5575637bc03b7528d4a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d999ef800d736ad5a8ebe7a6a9003dc5b67cab6fc0e309f0c4ae68d7fe1aea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a244ce78c996433cc7c191636110596d2ca38dc1c570416553839aa777c78a60"
    sha256 cellar: :any_skip_relocation, monterey:       "61d57e527ffa53748ea8f1ee803739db17717243c11ab9808f58b5aff7099b70"
    sha256 cellar: :any_skip_relocation, big_sur:        "981627f1061efcf36097872b74bd14e2671ead5fe1d27f7182a076c1e978402c"
    sha256 cellar: :any_skip_relocation, catalina:       "3f076f34bc26f7a38c0b8a2a6d128ff8bd57dd6b229ed3892839a11e784af56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ade43e1e6b8cfc82d90010bb8b79fefff02b667b07a888a18b8170e9c9b3a40"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
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
