class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.167.0",
      revision: "4280da7cd7f34234475c253661c001c08a563681"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fef1ae4689a0d2bf376c7681bae2dce48ad1a013c55848850fde49f5a5ae13ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a750df47cceefc0d66c8bada47e83f4b95485edaac8c984f5cd08d429e9af0f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46a4985ac88e0cf4893b5586049f0cdfe7f4dcfa18c35885d163d4b07f12feda"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca358d5990f367511a6fbfa3f93f760a248120b5eff085471cd395f92da41eb9"
    sha256 cellar: :any_skip_relocation, ventura:        "6dd0f20ab90b50819676573bba9ab8c81eeabb9287cdf8663aa9d33dc30ebaca"
    sha256 cellar: :any_skip_relocation, monterey:       "af4a6adbbe9081d5ca3ee0bbee79bbc7ecc88a3b63031a46077281c6df54f157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ee711223d9ed8b65d4efb5c08a90209d86ab880bf57673e9a0bdb8216effe67"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
