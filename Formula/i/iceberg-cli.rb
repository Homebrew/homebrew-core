class IcebergCli < Formula
  desc "Command-line interface for Apache Iceberg"
  homepage "https://go.iceberg.apache.org/cli.html"
  url "https://github.com/apache/iceberg-go/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "8c6bf515c17bd54127a20670f810f40ec1c4542ade2f862c07c323fa67718241"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2b38eb44e2c67ac5052a75ab9558b170fe5f751ccea9bc1ee64b1283e91c423"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2b38eb44e2c67ac5052a75ab9558b170fe5f751ccea9bc1ee64b1283e91c423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2b38eb44e2c67ac5052a75ab9558b170fe5f751ccea9bc1ee64b1283e91c423"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17b536fbdce49bffd7e5c5b2d46ad529f7938f896acd1a790f70b94c6a586730"
    sha256 cellar: :any,                 x86_64_linux:      "62bc87b45b98b11f6efaee5f4b278eb3e290fb348997383c2d5540faf8b544a7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
