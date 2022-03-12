class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.87.0",
      revision: "fb48f594ea8be763b6e12af2cfcbcb63ea20c33a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f0203c497fb8f942ddef52e8c043602f568ef034157fe36597b25fd98218e90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97a690af9c4de4d1901ddda3cc2ac1b0dd9dcbd4ac40f05c9502c986baca63d6"
    sha256 cellar: :any_skip_relocation, monterey:       "9a4a3cc0b6d1d0780959787b6719a816e0dc0adfd46617d44e4b7dab1bb54719"
    sha256 cellar: :any_skip_relocation, big_sur:        "094412795b94956c9588fb3cd4f0ece3634136347908cf0379e638c84b660cf4"
    sha256 cellar: :any_skip_relocation, catalina:       "78e47d2e13c57cf77cdd047b61711512940ab6432d81add22d1425bb9a91ca95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "059ea313ed505e2171b9a8961f4a6a25aa7196084b9eb9b32726c915cf5bd035"
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
