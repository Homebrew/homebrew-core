class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.224.0",
      revision: "be36fd4e253a61d4c30a6d9f7a4e9148a48e5477"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19f8dc7852474c7950bc89a79f5bd224e6668b67bd14fe0ca4fb1e58d74f7185"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb74f17f747b22d7018fd6e84d45f46262e5646a288751967f6482515617f228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10d2379599f3e137303f1a8965f49891999e2b320af22ddbca5510f3eba5ad4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d67e95959317155d4231552b24248f52b8e356ac3c2f6f7954189993da9421bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86aa7426ab91b699b0016b0ad2a85805a18ad83f50d447096fca717eb71038d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29af9e966e8c9c15f565959046cf6fae76693c1b5ec32ead90519283da5bc21a"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
