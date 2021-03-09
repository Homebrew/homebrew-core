class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.40.0",
      revision: "5597fa80ba64fa931cfc18759be03f841e109757"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfa238228fb8dad5823e5935c2cf390a632fbec5d4d6fe9e528010bc1b981032"
    sha256 cellar: :any_skip_relocation, big_sur:       "68e953223d6d57fc6bd2026b5c0ca2e835d9931681358c6bfecda4557b39cc05"
    sha256 cellar: :any_skip_relocation, catalina:      "c5ea78bc3fafae8f4f24e05c2ec262f343ae4e674b192f27ad34db1aef37491d"
    sha256 cellar: :any_skip_relocation, mojave:        "61128d694d6f9125badc49bc2aab868b27a895cf023cba08bd05931ef256f905"
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
