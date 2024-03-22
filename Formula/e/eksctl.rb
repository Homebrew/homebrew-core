class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.174.0",
      revision: "3c1a5c4c215965d88df40f7185fc21a16b11c3ce"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ffe9915d5c1f73ca0f6b65a962ad725f1965a46cc02d059ea5065f564363530"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ce70b0f8af711aaff62517eeda78c70c43a7cd847f059512226def83de76288"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204e8c00d39aedc271392c4c39203b6dfb69a5adc41c06c2b8d269fbc52f49ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c4cec9b18ed9c74d0392d92ab3d988890af1f90c9e3ba9200163cc31fb3285c"
    sha256 cellar: :any_skip_relocation, ventura:        "d81f72cd9a51a31bf4d9256443caac53a7df84afa1cc55a61aa6072d676eceee"
    sha256 cellar: :any_skip_relocation, monterey:       "587f8c78a55e267842e2c1ed74dd3c28df826842ae8e8a2f500db5c3edc8aed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39008c5862eefabb468c95e08dfc0fed278db104f163a3ae1cbde797b0fbc700"
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
