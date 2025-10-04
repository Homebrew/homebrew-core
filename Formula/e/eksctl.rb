class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.215.0",
      revision: "1df868edbf06679085b11025f1544ad92b5ef812"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee9ba8c5789c0d03443dd2f9696dbb2277a4845307cbdf9ae00250d554998a30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75f20f8c036d8c03cddede5c6866d4182d3e471465669dd3e404fdd02cdd2b44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "968e146759948935b43c231ca6afc6b6f085b6906e4ea90c65fb7e820288675e"
    sha256 cellar: :any_skip_relocation, sonoma:        "66d81f40aa07eb4a78085125010b2231af5f627461686d1e939110618b20d1dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3151472a94c7853c0042c6ab338e0ca292764d9a6e57da1a853f8dead0dee14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeac9bf8c1ba5b169c3f01a4ad94645e1a9d3fe2209c97c1e9e571c1ac2c5905"
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
