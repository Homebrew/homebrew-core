class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "v0.230.0",
      revision: "6ee3b761771c4ae78c76c82bbf2ea168afd61a9e"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41fa89e30a3a9828d86124e32644df97bccd9e637b9b5f95a1b7fe99eecce0c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc6403758f63ae26ec34881db41e45acc125a25ba4a4b2671dfff76969b7609"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b85a8a7c756304693f568ca594c85a85253f3ba07035f81de5d8a354daf96dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "87b5b47e0bf209a78513c4bf4b68fbbd5a1b233570c2f741b6b998abf2356fc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a2085ac39cbf61651724ceab61d57915fcf17dc01029d3ea3267d22213b129e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38842c2f7c333dbc066840255512a48add4f56b8eb5f64084fad4b24b2dc4ab6"
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
