class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.202.0",
      revision: "5c8b046f649e1a21dafad24e80f94a2e2c800d67"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7965b312de130c0708c39adae33cae4c270c199d2346ce5fff5b18e76eec9e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a591e74e17e4ace9ba248b839e3bbb5a2c53bb895d50cb0d96d45d4ade4d38bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f852a47db6dd1d6a197ce4bc614b1781944a5b72ff1da0de5e4561791860aac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4866c6236e45a5af42e07959b5b033cb061662b168794d924f225580b3507d44"
    sha256 cellar: :any_skip_relocation, ventura:       "86a75764063abd6e220c552126aae09a165f4cba76af8c7791db43b8c6250c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459798abaa076e0aa923f7a6c2f33f16e5ca8e820d76324fd51e31131c790b51"
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
