class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.62.0",
      revision: "607e787625d5cdce623c81217e39f0c0a4e7a475"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "720d7df48af2ddc33cb54d6196ad4f846e62e613d523017ca1e4fc27611c76bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f89698a5a544af4cc803fbc1b25b5fdbc3dab15db2ea703c4642b18dedb66b4"
    sha256 cellar: :any_skip_relocation, catalina:      "8a668ae6300bfb292a926ba498c229e69e515aff0e07b9650f06a456ecea2e05"
    sha256 cellar: :any_skip_relocation, mojave:        "9b42ca6a0ace85ca5caa95a8f0f5179c72f3c25f7e219a00b5303d2fc84bd7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "273f88847f4defe5255913ad6eb64915b7227bed0a42554b3ebc48d1ce8457fb"
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
