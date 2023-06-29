class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.146.0",
      revision: "5894af8988be4906c78faa48f81412f7be4bb98f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f6824cd1ba2e8d0c0ae3f3ec3145428d4a930393a5616b4e7dc1991ea568952"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21cd298de8ac9863430450da920f85c7107b449ef1af4ed1a2677f2850b06660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccaa58410a83bf93b0fad1ebbe90bdfde81d695cbbb5a58a250c2c98adabb765"
    sha256 cellar: :any_skip_relocation, ventura:        "9192ad6ab69436107f1733075e4299896c323216517ddb08cbd2e6d00347e244"
    sha256 cellar: :any_skip_relocation, monterey:       "4346343a3573005f5352c8f8dd2b316740faffe48a6e57e10a3c398dd038bd34"
    sha256 cellar: :any_skip_relocation, big_sur:        "64c3420ce44de8c4262cf810b517b27d9f6735eb73155bcd13dffd60a97e35db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb29a80498e7af6a0fbe9fe865986d07efbc33c56d2c10589c81a5bc2afc9765"
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
