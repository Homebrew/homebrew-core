class IcebergCli < Formula
  desc "Command-line interface for Apache Iceberg"
  homepage "https://go.iceberg.apache.org/cli.html"
  url "https://github.com/apache/iceberg-go/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "3ecdaa8851b84fa1c109be61b7ae6817aef6f301cee98ce68eac1eb649686050"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a59721565c616254f68c658a43ecbbcfa7c5787ae46569f8aea5f08ebf50534f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a59721565c616254f68c658a43ecbbcfa7c5787ae46569f8aea5f08ebf50534f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a59721565c616254f68c658a43ecbbcfa7c5787ae46569f8aea5f08ebf50534f"
    sha256 cellar: :any_skip_relocation, sonoma:        "029efcd4e4d7847001a907fb8d04a199d88b0f4cff5b74789639c55d26cbad71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "756172247d843244dc1daa9befb4f2460bbf0793f79eae5fff41fda24fc9267d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63e9a1974e458b473cb66aa69b36c4332d1caac6c5499219c6708ec8b26ac645"
  end

  depends_on "go" => :build

  def install
    # See: https://github.com/apache/iceberg-go/pull/531
    inreplace "utils.go", "(unknown version)", version.to_s

    system "go", "build", *std_go_args(output: bin/"iceberg"), "./cmd/iceberg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iceberg --version")
    output = shell_output("#{bin}/iceberg list 2>&1", 1)
    assert_match "unsupported protocol scheme", output
  end
end
