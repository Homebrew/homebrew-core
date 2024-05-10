class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.176.0",
      revision: "5b33f073a3b81365bf821e7c4eb7821ae08fab6c"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad132e11c35c2139a94dbb10993171f7ce1263369a5eb4e69f8cb91b1d3a0d1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30b4cb2dfc3910b1cb3590cc221d7b8c9955f469f6a473c0f5c5f29d61243d7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8debf0e397f054d9510c56216c14af7a92bf4aca570257ce4293931036ad04f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b41a6f37647dc28ce11952c31b13bf67dfcfbd1fdee2447ae7667b63d5389dc"
    sha256 cellar: :any_skip_relocation, ventura:        "74bb07edd0d510df1e12572717898591642b5bb98efdba4c3766ee96ef2c3a20"
    sha256 cellar: :any_skip_relocation, monterey:       "665ee872c59e577d6fd0333cf5cb01299e1751d89627d0e2445c2b637d401828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "244a8ed1164075bcdf7f4e88e0e80bdd91a3ca4deb6e7560990813e7a829bd48"
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
