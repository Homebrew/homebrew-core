class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.174.0",
      revision: "3c1a5c4c215965d88df40f7185fc21a16b11c3ce"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "547973667b197c05d7b7ecfd6e4cee8dccd8ac1465c951cbb0533acb9f3386ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94a4e0e7319d802c893723f2d98c79ebba1866c852435f93599ffe0a373ad871"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "839cccb994173244fde137504ee0e68200785f236373b0cd53ee1082c9088ba9"
    sha256 cellar: :any_skip_relocation, sonoma:         "98de41f345024d41e8cb0b0e10e8dde16bc53b205cc9f38044dd9c0540fd2abe"
    sha256 cellar: :any_skip_relocation, ventura:        "d01072a3d4c2b0f4158c8d8ab8eb1bc4f671e0774ff3a3a5909dda8b2d222110"
    sha256 cellar: :any_skip_relocation, monterey:       "45ae73f17af3571c7d4c1e45fdab4461d886e29dc0be65481ce1cba29a86b015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c1e650d8f535d279317c94656f36171cecfddfcbb47fdf201e49b921b0c299b"
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
