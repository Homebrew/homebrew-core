class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.144.0",
      revision: "92e3cd3833bc87ed527aec8c3f83cc4bca891671"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "919b54a0f08bc14aa191c11703fd0a1e08ca7fcb65329d2da216cdd3b9640743"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "471934a2d01d912688e11647222bc18a2209e1b5c6abca18d5bee30fbef752b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28aed0917764e9618277db960456fecaa7b672283ab60c4e9a40b793e81e2969"
    sha256 cellar: :any_skip_relocation, ventura:        "c98f3cfdc7f08fde268ad5010a2ce85a3293cfc0e40cf621ed938ded7b831588"
    sha256 cellar: :any_skip_relocation, monterey:       "10bd5065464f8201be1af821b15f97b4291fd8e931219186abc6583be9a082de"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a3741ba24c16fb3721428a02a26f241727f93ec5c758ce2c44b05fccb9dae1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c31b4ff413911dc4266d502fe900ef2708ecd395ecac03dcdba8d36d172d6a91"
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
