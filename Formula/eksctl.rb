class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.76.0",
      revision: "e247e957bbc9cbfe14fc8124398b8b459fa8268b"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc764cb93a3f6aa9d48a4b1a30b2f5258ff41a9a882be5aa58aeacf13afc8988"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5dd53f222fee5fda04668a46078a0144910663c4b25022363e7c131593de8dd"
    sha256 cellar: :any_skip_relocation, monterey:       "873127334e7be92d688420f97143f880976e4a13e3892d894aecc82b9779b608"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b10627b28587f0aa916883d80248dd375231f6d89eac01e6e454b98dcdfc6f5"
    sha256 cellar: :any_skip_relocation, catalina:       "5310d3fbb60c399b9298ceb4823c1180b1c6984a1c74a313a2305bb775415ccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22e08b4d92e444a6663c7396d9c1a8d992c7f5e64782d78a20edcf21f64d9f9d"
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
