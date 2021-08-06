class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.60.0",
      revision: "de0005c8b28c8bdb9f50f5d7a8bf366f76f3f80a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ab6a8eb1892e075f41b16e90f3f843d3d2b201f53f8124db1dbf0ea73608a27"
    sha256 cellar: :any_skip_relocation, big_sur:       "21beb0c4e77bfd120a33cddace30e9a24b3bea8a61d92a471e63dbb85025d25a"
    sha256 cellar: :any_skip_relocation, catalina:      "cc8f148883f8a6e10a43f0c67a380870a08a16d9155fc6a97b650d1fd65c5d43"
    sha256 cellar: :any_skip_relocation, mojave:        "b84d56c05336c6574770b2dff0de930b96032e4a5559a8ed4cabf81714c63908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97fd10800f1e4a5f7f1bf065b8b917e96225361e371f13c22cffa62614e85d8a"
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
