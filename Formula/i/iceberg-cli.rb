class IcebergCli < Formula
  desc "Command-line interface for Apache Iceberg"
  homepage "https://go.iceberg.apache.org/cli.html"
  url "https://github.com/apache/iceberg-go/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "bde108f9c61e2976c02cd9460d887ed875289a1bbb98e247466c093c4f0fd7be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48004d523e189b27b46fedf18581e91bde99b85321a185c7e6cb558a069a9c5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48004d523e189b27b46fedf18581e91bde99b85321a185c7e6cb558a069a9c5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48004d523e189b27b46fedf18581e91bde99b85321a185c7e6cb558a069a9c5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6dc3cf47cbe3bb89eeba7703bc39215156480cbdd09d929f9a3438bafec591e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "640815332e781bc84780e0120611a7ab9eb588257220ab19c229a46730466e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5341e3ee9ea0366f779d961302f341926391ac17f291ef0e18ed1a64f65e5a9b"
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
