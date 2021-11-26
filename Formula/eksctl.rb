class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.75.0",
      revision: "e57be033cb92372c6e0b9c0d18a1129e0db15440"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b187e34fa43bda6bfca5c9734eb7cbb15ba860013dac6104ff89419453c0344"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81064fd4e23e37ce07dc9795ffc4df545689ea7cfbaf45e5b9214b014de050cf"
    sha256 cellar: :any_skip_relocation, monterey:       "e4aa1a3f9878a45ca5e045b68c6d3f56e74ef668bdb921a66a3e5cac17dd9156"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c7e2da6b8766980978275d62522750c67b95dbadb49db07d3f3d05f6d23bd2e"
    sha256 cellar: :any_skip_relocation, catalina:       "373c7bd89090fb1eb2ea3a00597754a1623d67858b97acd3d97c810e65da10a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5a3419fbf5c0a09a578073aeb40cbf21853b01600706a47722195731db9abca"
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
