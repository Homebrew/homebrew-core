class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.42.0",
      revision: "64144d16a260a84ae7f9b9ca0fb354412d45017c"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ddd68e8af3a6a30eabaaaf34a2bd324c07d71cf308dad8bcb3b1981c4b3d2bca"
    sha256 cellar: :any_skip_relocation, big_sur:       "c39dade1f7c4e534b905f20a8e86ae2434fcc45eead0d4f7923425f5c1267f1b"
    sha256 cellar: :any_skip_relocation, catalina:      "1268ba60abeb452c3f880d500ae62264a5e39a7eb12f840f0186c6df657545ee"
    sha256 cellar: :any_skip_relocation, mojave:        "856b5942bb41b9e0ea1f162a91edb2668b74d5b5e485e06cff712222b4e1a756"
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
