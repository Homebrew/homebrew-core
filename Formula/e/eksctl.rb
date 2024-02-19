class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.171.0",
      revision: "9858c5482a31e08037ab5794e73493c8d18cdcb6"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93e1120d0809c0016a3e1754d934e5ae2dd9131be3873c69120cc52b3adc0c7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91ff4d212fa6bd18b95c7dd85be9aee3aebfd2014f495db1c460b921acacdf29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "324e6cf3720a9c768d4fd55f5bc1193aebb34bd5a110375bb9ff540f80167dc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ad9aac351f816b7cef4adb31efb0b047f2fd42d7e4ba4de3a4e8112695fdcbf"
    sha256 cellar: :any_skip_relocation, ventura:        "b9d0e4b5179be7b726ce39d9148dca76180bf22192ff2000f6561f8956d469e2"
    sha256 cellar: :any_skip_relocation, monterey:       "06d73d9c137b62b3688c5a66d9bdbd32fea13aeff6154642c36f65b7b6956421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8990ea01fcfd773d418c3d5b762bc2ba6b83fd5aaf02aa503733506ee598ab8b"
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
