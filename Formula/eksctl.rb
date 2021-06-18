class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.54.0",
      revision: "6ffee769170bbd5713584fb0d53624e76d859ac4"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5940c8c67cffd466d731742ec5677f61aac05a163acf78e28b46161e91fd33e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8e818aaaa5275e64e754e95c08719ecdd01b6954e833cd43fbde5bba290ff74"
    sha256 cellar: :any_skip_relocation, catalina:      "0da345099d87a9806b426cc2f85decd5c5d1dbbe3078c0d7fe9979ddbe97b1b1"
    sha256 cellar: :any_skip_relocation, mojave:        "9b264aa0f29531322e9637f04179d27874c951d1952ca0966d0836f53fc4afff"
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
