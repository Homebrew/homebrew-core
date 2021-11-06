class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.72.0",
      revision: "5fccb69c130ce7f64c36fb6451b1e1470df9b5f2"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3ffef725397168d445101286e3949aefbbaa8db690cb7e4db2f17261e89a0e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5571853efc6a4234a2287f4b9697be08628bc3d6c990e0176024dbd6c4699032"
    sha256 cellar: :any_skip_relocation, monterey:       "e71766284b721af928d943a5aa34d8fde871976b0ac627ba3b0f9f920ccbe049"
    sha256 cellar: :any_skip_relocation, big_sur:        "795dfe41ee076c1ff3bc9d76baa0835f4797cb2a3e48448e1f4547c6ac8c3e07"
    sha256 cellar: :any_skip_relocation, catalina:       "09f814d6157525b5746c521d1d36e050727da4a90cc9263ef5bd3d42e84a28ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2ecfa73f16de7ee89c045c224a18faa2bd3714501de1135fbe064e58339df89"
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
