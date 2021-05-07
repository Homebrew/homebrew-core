class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.48.0",
      revision: "0baafc637cea604feb0509bff31432dce4b28e3d"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11cdeb28262a25ea5a2f4dff67cabaee8affa750d5121b85497fb5565f953d7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "b759cb5b72f7ef4e2e37a44858e63bee08375452032387a98548b3eefca50373"
    sha256 cellar: :any_skip_relocation, catalina:      "ddf38932004c6df538175177f245daee54dfeea6140d210e33b7b2bd00a71e7e"
    sha256 cellar: :any_skip_relocation, mojave:        "53cf67aba13696bd80cf04b8f0ca0bf7d48e3aaeefab17a8a0d7d9151a58f11e"
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

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
