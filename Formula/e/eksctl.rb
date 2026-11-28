class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "v0.232.0",
      revision: "69bb49fc68dbd532398c78abcfca27ed43df85cb"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    manifest_sha256 "02ffbfb002dbd6b973de45dbae92cdd1b04752ec29b6d446f4a2efa16870565a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dee1619c05f66c06e827a6e6c9f8263d7be561f35f4364a33876388a5afa1d0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7969714c4a6e1bc0c0c6d07645da9bcd87db141823ce6ec6d79144e6813ded57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71949195ee0d6f28d8e19e6b21b0f9d95cc79557a50bb018544f30c666fcd967"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80735f03facc217893ffd974c030971469600c01d98ea1306514a337b1cd7d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cf88a9eb807ebf7de773f7640dd74734cb58da4e32f8db819fc04c2fba6397dc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
