class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.52.0",
      revision: "fdac193c7264e2fb76c025ac1e01f08708b31db6"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "104670bbe025fecefe233d0d264e6daa46cf8223441f8a80542a82023b3c8dfb"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce9b24ce106dae1bd3994e2be5eb586658587af9294338203c74f642a99c97c2"
    sha256 cellar: :any_skip_relocation, catalina:      "a8eb228bbc87bf3cb135dee92bf2a0e4e14a953bde92d48da8ac835ff2d9b97a"
    sha256 cellar: :any_skip_relocation, mojave:        "9532bbcab0dff12cb63969bc1b9d0d8e3704a6e6db6b19ba676a9aee5dd6346e"
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
