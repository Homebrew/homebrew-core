class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.58.0",
      revision: "b7f44919efb422f9ee5ccc2622351e8764b3123f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c1fced23df0df09bc47d22e2619ef7baab927f02fb0db1625edba3b2478a628"
    sha256 cellar: :any_skip_relocation, big_sur:       "239cd54612fd5397bbfdd2227b53d688022c28658602173493194b9871574ba5"
    sha256 cellar: :any_skip_relocation, catalina:      "26dad9d9b3203923e5d19f81b5fa4ff7c1cac7907c965ad47396354a53f118c9"
    sha256 cellar: :any_skip_relocation, mojave:        "d8f856ded3797575ad0ca76edbee309a763466ae86c02392d707af88630f028d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5697b3ee6e210541734b46907247ffe6b12ead44981932f0153933b34f248d0"
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
