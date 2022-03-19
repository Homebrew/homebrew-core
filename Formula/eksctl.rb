class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.88.0",
      revision: "f71f0f864d9b79bfc8f833aa0e7f2a46882e1e2c"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97c6a854c49c2615be1dbb89b8a519f9c0c99c33bf806b31ee8b7d273aa67562"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c89382b330819c83d498fb58a7f4328fa6d16db9b677ea67acb8f03c15f9106"
    sha256 cellar: :any_skip_relocation, monterey:       "a1fbe60b7fc46d1da4581153ba5a8b496ef0d1232b34113057cdaaab292bbc0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ec799e9e30576379b0c34a921b4da4dfca24c5ef36bbba04dfde0364dcded95"
    sha256 cellar: :any_skip_relocation, catalina:       "b87731cec1b16702c75d33bf16e02444aa66e93efa5ccbafeb6e5706d97aabff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdad6cc5b32bcf33688cd9c084e0b96347548bca6636889817095880b7bf612f"
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
