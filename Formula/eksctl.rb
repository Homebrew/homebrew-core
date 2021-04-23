class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.46.0",
      revision: "50ebfc78586ede7ef5afca4e85dd8865a81c3b43"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb46c698f4280785b97d8dfe15d7b7962cdb7cc4d1c53783d93322106b606cb6"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae76d8ef171c1db8f9da4543a26589561ab5228dd486e9c77950b3416184fb15"
    sha256 cellar: :any_skip_relocation, catalina:      "776166a2ae945ad30d38317ee893036a0534d723209ec59f90e4ff3f91a3e4c0"
    sha256 cellar: :any_skip_relocation, mojave:        "47320fe344c3ef5a93ecae0ceb306a82b47ddb0c836ac7673edaba104a62faeb"
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
