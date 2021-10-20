class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.70.0",
      revision: "fa01aab33e49d23801c4fd85c7676968ecc36860"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3bec3ae19ffc521154b8f25306a3b8f12ff48d1c97d5e08ab45aa419f6e5414"
    sha256 cellar: :any_skip_relocation, big_sur:       "dbad947e16c5f6ee8e0628b50fb8da6322cb2bb3135f3be57a2d451df263d750"
    sha256 cellar: :any_skip_relocation, catalina:      "35dc673583a0d5d9f020ec4a24fcbeb916c18541503755fbd510b2824bfd3dd5"
    sha256 cellar: :any_skip_relocation, mojave:        "4576506f25174a16c873dbcbba05eac804a884e9c114d76da5a4e49d73f952ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a3ce46a151315ee01fc8bacf6070a6ff2662fe8f9d22ff7d2cf229d5fed2566"
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
