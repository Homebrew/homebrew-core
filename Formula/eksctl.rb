class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.82.0",
      revision: "254eca4e9820628f9c48215f7d861663aae2a26b"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ad0724dfea4ef062b85059b6a593b35bdd0c477dfe5160ebe53eb8c21193b2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb4f3c1b0b1430a3d6a2dba65031b2c1adfbf95b3a934e14762aa69d67ff45da"
    sha256 cellar: :any_skip_relocation, monterey:       "86ba6cef159abb242ff00100bf7b8fb56d9f1f8666a94243937f8fe62f37958d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1ccde6a7d6f927122a18bde9fa57c21ca3606b76451c1a9bcc7022f6c4940f1"
    sha256 cellar: :any_skip_relocation, catalina:       "e3262f5d324ce2c5b245cf23f64d0eff8c7cc28bf81337be60f62292f209d15e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d520402b635057288f4fa2b9453f37e29ff37f07767cf6921ab22569919a587"
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
