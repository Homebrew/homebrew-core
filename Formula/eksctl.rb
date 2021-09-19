class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.67.0",
      revision: "31c56bbce574f00b0b21da743731966bd052cd86"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b786d254d4da7bb45aa815786f0a7b2b47b23c6503fdc2f1696eb1466916cfd4"
    sha256 cellar: :any_skip_relocation, big_sur:       "402ef3155841a09cf3bebb45b4019558aef527f5aec1733d47fb7c0e3ad7d02d"
    sha256 cellar: :any_skip_relocation, catalina:      "fc0438c949fff252050aed24eaaccba0692aa3d9998c7d09067a122f28d1017d"
    sha256 cellar: :any_skip_relocation, mojave:        "1bc8c99bda7196d7be81e7ac7a9b5e67a40dd2f22aa54880fc5c3fe226fdb7f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "204f3cb811b107c4e325207559afb3b87922698cfbfb54bdf23d8870b7f38335"
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
