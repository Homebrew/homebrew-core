class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.57.0",
      revision: "2d4ffff63de4df00b8f1f84fcfd09c3613bf4cdb"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf03a4278dfa8a0dfb2dc5bd81d9833f079978fb531c19c9a12caf47e759424c"
    sha256 cellar: :any_skip_relocation, big_sur:       "16b6280616be0c120a3aa3ae75186a88cd8ef9f804b4610a6bf9c5c555d22f12"
    sha256 cellar: :any_skip_relocation, catalina:      "779296c00082468910629bfeb9f9ff22f5c28a704158f2a999f05aa20db21b97"
    sha256 cellar: :any_skip_relocation, mojave:        "f81fa3288cc074b3e5006700e412163c4d3f231fa868cf08ca0c1c11c0464693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f43fd9a1db56c7d857b95fcbe0914ccd04fdeeb96b35c70157050d662fccc650"
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
