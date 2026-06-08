class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.13.tar.gz"
  sha256 "ea78f41bcbea5abd5446fc5c03863057bc6eb3484ff7ba55cf085d32b1e95672"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af290a1925b93b7f5855ea1427806c79fbbf38a0d196d840cde07b7d39efd83f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af290a1925b93b7f5855ea1427806c79fbbf38a0d196d840cde07b7d39efd83f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af290a1925b93b7f5855ea1427806c79fbbf38a0d196d840cde07b7d39efd83f"
    sha256 cellar: :any_skip_relocation, sonoma:        "528b3de430c3438b2a4e95e5a9cc53f141e5378bfcc9c88d9f4dc37bd306d7dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c9105638db80c6da819ec2e0925431ae842164746832db5195d6c099f6aebb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac83591bc43ee9f6e9aacedb6ddbe6158d3d6e6093e1928dbafda859df508d13"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.name=berglas
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
