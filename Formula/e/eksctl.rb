class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.172.0",
      revision: "15a9f6e37734b7a6d35dc6bb4e460c0f228c9564"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dd07f9ffe33c4fc60669daa8832a39e6f85aab3e7091c8aaa2b98f6f8516b8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e1f6df1ce5787d258e27e76c37e25c4ec6d91fc3804ba1646d315d39c62260f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "319b10112ec6a12ff8098285995567a70330242eef21fe4d2109fd4a6db67251"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb071a893f4d3b953b8fda58b4422791b62bbbf3c58de26e760cc94e1126c9f3"
    sha256 cellar: :any_skip_relocation, ventura:        "77fd59ee57164bdc579cd715ee911d17259450ac1eb5f4c1dbba83fc69e31a42"
    sha256 cellar: :any_skip_relocation, monterey:       "3431ab618ea660be10e06cfdcb9c73fce0092e0131fd6ff65affa4352851f766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1f47e5c5aa6657cd8fe1b85194f8bbb35133c90040c7fbeae2f2c0adb9e1166"
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
