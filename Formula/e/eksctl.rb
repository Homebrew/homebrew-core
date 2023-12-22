class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.167.0",
      revision: "4280da7cd7f34234475c253661c001c08a563681"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc4ff867f8a8c5e93c4cba13a2efae8e6fa8a3cfe61d033f2e827a9f38c8aa95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6335e9be07a49b8fe6be5fa8ebfe4f7b803e27c3a79b5da1dd39578afaf1230"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8a69dfedd79b4fddfb440804ef3a6c79e1ee20963b439493b30535fe7118a3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4eddfb393420a893610d54304d896d1dd3b067b1f5f875f93a0a985425b173a"
    sha256 cellar: :any_skip_relocation, ventura:        "036d77aa03aa33db95f4e8e96fee637191b178c93b2c47e62ebcef1f6bf35234"
    sha256 cellar: :any_skip_relocation, monterey:       "d5f6687e8f070aea1290f9e1a6b6685bf37708b7da9ec658a881bbd813d14abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "410718d031e8e6defd05422a3995b22653c9191bd1cdbda8dff009b377fcf518"
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
