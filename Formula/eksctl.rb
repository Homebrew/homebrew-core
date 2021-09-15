class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.66.0",
      revision: "2c931c8bc3b0fd74246b282c2cd99a38304b0295"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb8e228e047a88791cd88671c9d97ef049d6cba3712498c9ef8479582cf4434c"
    sha256 cellar: :any_skip_relocation, big_sur:       "295bf319ceefe86fce441016d46e769763b6ea8461869f62eca61e38a7369b60"
    sha256 cellar: :any_skip_relocation, catalina:      "092c3d64e244449a150ede99d05e78502d422057e3438c3ed22d2fd398060089"
    sha256 cellar: :any_skip_relocation, mojave:        "2d938b00ddfa3ba875c4f8abbcf7cecacb4e37446be4b340d43eea32230bfeeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d2ee8b7a25f5e3fc90611ec67f8e0f69ae8fe4b66bc2b450c8e045937f1bb6"
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
