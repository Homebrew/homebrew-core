class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.54.0",
      revision: "6ffee769170bbd5713584fb0d53624e76d859ac4"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b147c1873f9c81567785ac826ba1770685e999f8747418c7b9fd09054f88017f"
    sha256 cellar: :any_skip_relocation, big_sur:       "baa008735665915575d01f581d8ded401b6dccb7a6ba59f8ca70a50f49733d81"
    sha256 cellar: :any_skip_relocation, catalina:      "953a9d0dab21be6bea663a89db7ceae45f427c9c44ec72130a1f13bc1cf265e3"
    sha256 cellar: :any_skip_relocation, mojave:        "9a9fa173bde4cdc202c7fe1febeacc3aecbf7f970cf14ecb88c8e5291af04466"
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
