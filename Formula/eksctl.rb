class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.87.0",
      revision: "fb48f594ea8be763b6e12af2cfcbcb63ea20c33a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db01df679a775afaf81598cabf21c3b86f7a12d292f6b8026f254950879a3194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d38486106813042a0a36889dd9afbedf2b7b7825e18786cef2fbc669e494d422"
    sha256 cellar: :any_skip_relocation, monterey:       "fc965392f8b1eb258947dd04bcb56ad597ab8fa44fa28aa5ac0af8c472e65c60"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd2faf3ce0cc2e193e6ba326148553d3eb0627c23661f8582c95dc9fbeb590f5"
    sha256 cellar: :any_skip_relocation, catalina:       "a57a23321e86d1fc362d611c543e4f47b32e415599ccef08380a5cae05a02387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5d6cc576399d95562391f76b1259a93af14edf735aa24803d2ef6f705c5c856"
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
