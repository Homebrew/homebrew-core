class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.60.0",
      revision: "de0005c8b28c8bdb9f50f5d7a8bf366f76f3f80a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cc7f50480975c6d5d0a8b58a166d18c29ba82ae41eb4007a76a3d4265ecec07a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ba6c72cfd039c1a977606708faa7b4e13097a78d22e5fb81f3ee75b0c35f97d"
    sha256 cellar: :any_skip_relocation, catalina:      "66fe37949882f788d2108f82e3a7148ee419a196dd3c1cc6797bb1f8677b03ad"
    sha256 cellar: :any_skip_relocation, mojave:        "3c5d516afb989d80263229f5973465fd74acd6c728e77244df3fb1eace9d3386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1905bca97a5bd050d039212c06b553f563dfb1c05194be3f97a462ed0b9ce04f"
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
