class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.201.0",
      revision: "608abc3294871009a892ee69f6abf3ff9e2a8267"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "012229bbbd2e4777319d7365936bf3755ffe1ec857a18f0d06655559900124cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fdea334c74237698c4b65ff8e4c7e2fd45cdec9467aeb2397a9993c943bd97d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdf69fd1884263ab22b762c825a9505629dea3ad203c347e597effe94997eb4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2601701ffb50dcb5c1abee434c57529279d702e4fea0b24040cbae3ae514c3c"
    sha256 cellar: :any_skip_relocation, ventura:       "48449583707555e6eee6f3b482f0d91b46519ef3926eeeb5a1ff1e1d8b205c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2707c6c27625367169b9ca22ba0b89a6b4f7039b2dc1ff308a03c628e7cfef5"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build

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
