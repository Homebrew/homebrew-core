class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.77.0",
      revision: "d7e5bc8cb027b6b44aaf7c238988e29a354bf913"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa035c0089bd53a26d3e0cb6d5eb40e95972d0f36569d72a7deb53f934e7bd08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "233e6661a13265a47a1fed3a072254b94838b1ec0830fe5f6f64610fd04f5256"
    sha256 cellar: :any_skip_relocation, monterey:       "8faa50f94ad697b731dda98c1145626ae35d68198b1ea5c8c3fb3a86890e2144"
    sha256 cellar: :any_skip_relocation, big_sur:        "52734555da5660b55c229d5d9fc37d2188fd6f0c75d9f27c5fe8e0262af0574d"
    sha256 cellar: :any_skip_relocation, catalina:       "b448655a21a126fb81ed5dc6ec69ed4d9c7e950772e0a816aec16c426e1dfdbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a16d7509b63a979392c7d0e55daaf78fa220fef294115182caa608a5e7b16b11"
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

    bash_output = Utils.safe_popen_read(bin/"eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"eksctl", "completion", "fish")
    (fish_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
