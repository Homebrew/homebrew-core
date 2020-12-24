class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.35.0",
      revision: "1eafbc7b3fa3d9c31575b51b8fbac718ec108051"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a8ab91ea8a6e3925c0fa6c3faa9f3eb742600a3b7710ab2da2d7a2915abf859" => :big_sur
    sha256 "d9d82c69ba12a5a4a814bcf6c5c0689e22da71d3dc13c03495d92a0d50824819" => :catalina
    sha256 "0262d856dd6219204730bd3fa3bac93866e6f0cefd7e0c9b5ab637424d5a42f7" => :mojave
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # PR ref, https://github.com/weaveworks/eksctl/pull/2987
  # remove in next release
  patch do
    url "https://github.com/chenrui333/eksctl/commit/2207612.patch?full_index=1"
    sha256 "50870dd22647f6b6252678fb5302c81aa89ca04177f3f327a044d301eb483c14"
  end

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
