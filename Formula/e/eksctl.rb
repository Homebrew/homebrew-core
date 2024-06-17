class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.183.0",
      revision: "a8f8fdf2eb2afc44c661717bd65de0cf2e84a376"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e53715d38a5bb4e845d02b148e03710970d7c55e1e9e50b4463dfc85e2f251d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0fc5a84f8c8a820ced257ef1d9e427fbded0465254b0bccbaec6cb2dbd3fa2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9950cf542d597c04f6435cdd6b68738a74b2b2bf7c52fa61d9cb4db8bc4a23a"
    sha256 cellar: :any_skip_relocation, sonoma:         "96045b02c7486f9d29af23425916d8ed5d53fe61f74ddd98e7fc3f6452192b93"
    sha256 cellar: :any_skip_relocation, ventura:        "6faca7aca059f276b4305e175f1a4887f434e7296c9ac46f9867a420638b0c0d"
    sha256 cellar: :any_skip_relocation, monterey:       "176bde673208d7cebe38b32e56302d8f807c8ff31150e124ff0e41b0bac1197b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb9c083cc40603c475a90132f67e0b210136fc57df8dd363272b9a9e4c4753b3"
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
