class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.36.2",
      revision: "76d97c7e9bbcb34240477afcf2152796fdbb779f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "810a8987605466567337def9e34362aa810e662ffd6579c1eea8750384213e93" => :big_sur
    sha256 "ab0559d742f414bf1a479851f2722f242bef83ff7047eda26de55831989fc4d6" => :arm64_big_sur
    sha256 "d660e4baae8cf823104b462f770019eb384fe6aa2f4f180468cc2e0a2a6c14ec" => :catalina
    sha256 "10974c27750cbfd4cf85122061bc288ca823852bcb2981e84ed3ce4a99c0d35a" => :mojave
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
