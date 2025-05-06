class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.207.0",
      revision: "87e1d6e6eabc73115c92f29edc03785d9a398a7d"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "021338619fe5fc1224f8a123a3612fc5f701a7420d4d5495437baba66253d381"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c8196b9d93aaaf79287df6d74f1f536922f80c8225e692e8fd6329720f5079e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e65b16309e2640e0a02fe13e38c3bc9405f389af3edc2a35193888aef32fc22"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5fc9cb18b7b2a82f8a34e9b5e5e0af9c239d48da4cc17d988ea2d479d38c28e"
    sha256 cellar: :any_skip_relocation, ventura:       "b7db237992c5b65551fb02bbcda11373fd5bac895432ad2271a3df3f41fde09e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33c7d893d1c8eecb4d5ec5ae443410433d1607aec43adcba5d7a2e36453962d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e756a10fc54ffff4b541b9efbdc5259ec6a8c63589bb1167c5a0b5781274fd2"
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
