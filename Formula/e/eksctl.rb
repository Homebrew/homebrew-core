class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.217.0",
      revision: "d8988e840ac644a3ea327cc1783be0c55a1af439"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "594d1945a64bd708af414a82fd0c00780dd8e16bac231934bca3c38b14c7f452"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2e932044ed7c8975b6f903ed31619b4acf6ceaad8ca0ba6a8ab72560f6b7671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cde6fa53b359e781ca9143ecb1603aa3896500af85482eae4ebe7209bb627c86"
    sha256 cellar: :any_skip_relocation, sonoma:        "c882df04560f5daed3e7886cd1795af2105df99315fd84bf1ef84fe5f741ae02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce15c5ec7f1aa332063494ac3b02a38ec27dc70c5b926b4ba37bdd4b55d0a892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5c18f98e988a575a1898ae5438d48a1a7bde48a25544bfb3e914ddbd9534b24"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
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
