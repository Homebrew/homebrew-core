class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.84.0",
      revision: "3ca2572fbbfc8425706fffde41de6079acfa0387"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d33f48c4795db90b909aa753c9c4bd1fa7e126a653ff6f64d93bde8654d1c45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd65d56de40f4813173f3c629e47c43978a45125fb18f446a9d78e508059aabe"
    sha256 cellar: :any_skip_relocation, monterey:       "31fda01edc65e8f16ffe733bb4d6e6013d85de827b73320b9595eeecce9448c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3b0ad878a738818ae0b239eb1e0350eab24c7ded9c58120a77d6d361ed47166"
    sha256 cellar: :any_skip_relocation, catalina:       "c7a0647ff654410cc67a4bfcb5212822449ca186cce745a9a7c207ac9c8fd415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a94fb70c1f5bacbe5c8135dfab546c45f97c108c63aedce3c035691f19126b4"
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
