class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.86.0",
      revision: "a6426a8f1f953b86a4b9490cc32c16f593e45dd2"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77ea7775f71cd9f8bd5a3985a89eb1a34c652765f78a648a9e4ab99cecd60830"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51b8743b48d795b926dd2adcdcaae3cc52218d8ea42d85d6094704969140de12"
    sha256 cellar: :any_skip_relocation, monterey:       "334d02c3017dee942ca5103dc72e939920ced168fa680162b216e475b985d015"
    sha256 cellar: :any_skip_relocation, big_sur:        "00adb5d7e5803baf0910703b31a65c050505bbb9323d3cb068fff20b2b1b0d94"
    sha256 cellar: :any_skip_relocation, catalina:       "218e3253c495c40daff56f627ddb0b80b7ad21ff1693b9fcfc9b2d4fcd2d059b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bdc592e79b6697c654fa01305a8031588a73d903a770210fdd5813e2d36e5ff"
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
