class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.225.0",
      revision: "02674beb75c9346abcef72f9c1e755115f85db29"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a3d21e1b4745ce283c125e6952e7db8bc84e3097f5e542bd49352ad28e7b2e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dae868824b4a3672f8d8131ededd5cb238d952cf15ae2be46c11dee157b0b5dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fb87d852d34c6f73ca92de866a9732ebb5a2c5fc7f0977ee52328a14b57afe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fc2e15b468002d8535051b996a77f35a04a8730dbcd540a442b70000014197f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c7ed0fb5d3e85d2cebd20a0893af275d336f91fbdd1dd76c9e8b569957d0218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b92f8602b64ef29f4916e07a91e26dc387e5b41e887521709d54a86304f06223"
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
