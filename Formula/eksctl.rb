class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.82.0",
      revision: "254eca4e9820628f9c48215f7d861663aae2a26b"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69e21f25b0194a04bd723d3018212f63a824bc1fabc795270ef73004d351f189"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33eaadb68eb717009da7abba788d898c1b0f9eb792e92308dd9e33668b45aac9"
    sha256 cellar: :any_skip_relocation, monterey:       "f15c6ec75992d92fa6ace5b77aeb61f4fbe460a3bc26ab805e37c9913df21f1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb2dd31b8008349fb02b472515202e64eaead94aad9d18335e7e8cb4dec8b04c"
    sha256 cellar: :any_skip_relocation, catalina:       "d16b85f024258c49f01886d4312b133a644dba3872a099fffe20cbf8259eb40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3abc6904cba274a425f4f6678a804436271980e91beced9d4213be33d8464639"
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
