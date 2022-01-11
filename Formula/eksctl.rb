class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.78.0",
      revision: "a23e50495d0ffe9645575aa524845022aad79c07"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d980c16f0e3c9a98164b3562ff75e8a2273afcdec5bdc4bae0b6e1cc401951bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b7e17d157adaa55db83bf0f83e2547efcda22d297a7c0c7b97834e744e67d9d"
    sha256 cellar: :any_skip_relocation, monterey:       "06a5fd0a4e4285d87ddcf108b6aaf93136fc23a352bff23e487e3bdaba7a4345"
    sha256 cellar: :any_skip_relocation, big_sur:        "724995d3517211c4605dfab35d533818ff01639a89de3ea0ba26f548fbcc731b"
    sha256 cellar: :any_skip_relocation, catalina:       "61e7544f3e379459006579cdc2708ee08295604731455f39f7e2e005871694d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "529c02c718cd2b2741c8b7bc6fa6a083ea269a5d7928ab09f798042889317650"
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
