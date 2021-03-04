class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.40.0",
      revision: "5597fa80ba64fa931cfc18759be03f841e109757"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5af228921ac8c51fe314816e437ee43c6ede504b565192a38e2574ab65e565ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "cce84c64f95583217c1efb6720ff2b6116bf02b966838c951d3c171d012839b1"
    sha256 cellar: :any_skip_relocation, catalina:      "9839e54e7bc5bed981b46bb6a89b60ab2a7c3f69afb39dc0972e490c1ec1adb1"
    sha256 cellar: :any_skip_relocation, mojave:        "eb0b75e102a4f9f97459fcab28b88d4da6fd61eb7440b51739f65aa449ce2748"
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
