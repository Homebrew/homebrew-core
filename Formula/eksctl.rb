class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.83.0",
      revision: "bfe44a15f67c98b5ca9efd96517ce341249e779f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d0f430a52878cd6c673aa5d2504972ffa84609a34896811b3d519505f81c813"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d1509786c38cf439c77a4ada0b0f4986562ca94414fca6b69c7dd2ddba16195"
    sha256 cellar: :any_skip_relocation, monterey:       "801834077717743bff84ff53564d6a9cfc2419372205fb67d8bdf92aaddb341a"
    sha256 cellar: :any_skip_relocation, big_sur:        "37b2908c031d16338f46e716a149e3a90b32c92f67de0156a65be8c6c8d4193e"
    sha256 cellar: :any_skip_relocation, catalina:       "0e3dfc20730542b7e94cd3022b1155ce7e4a56f6fa25831cad383a967cb81e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb547640483709c542814e047c5b4b46b044ffc0881cabe7e071fe093e9c3297"
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
