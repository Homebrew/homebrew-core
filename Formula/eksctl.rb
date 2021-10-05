class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.68.0",
      revision: "9e1484bf864fa2553725543aba211ef783ebd569"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4680b9bc9b0e864e2a5a07aabd7ca37a603a5e3d28f06bb4d3a7601a07dbefb1"
    sha256 cellar: :any_skip_relocation, big_sur:       "1bba0efae672ab7ee1ccc570eb282332534a54bd77f29133ed408f36c410f981"
    sha256 cellar: :any_skip_relocation, catalina:      "f4f032902efefb2cca5f4c5d80fff934e0386e2adc5956a7388fd33353e3c9ef"
    sha256 cellar: :any_skip_relocation, mojave:        "7bf49a029358c486ff4acaac9685e2226a07da9ddc06f3847362852106ff4f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "078ac56b7a878c7e4d285f0f6cb4d9d2ac61ca0931ad40ca0e691a16ed7a6a8c"
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
