class IcebergCli < Formula
  desc "Command-line interface for Apache Iceberg"
  homepage "https://go.iceberg.apache.org/cli.html"
  url "https://github.com/apache/iceberg-go/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3feba9ae3a0bd9d9e958da8f4a517718c45f7a01a45f11a87a176cd6f33c96bb"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "2a9e6be72e19883807303a8183fe2aea81635970b2b631c4c82281b004c8b83e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92e05be721ef818f0abbcdbdf798ce910fb0997597265293452aef053de5ad8d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "92e05be721ef818f0abbcdbdf798ce910fb0997597265293452aef053de5ad8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92e05be721ef818f0abbcdbdf798ce910fb0997597265293452aef053de5ad8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "047d49a02cfcd8c66fcdbd3236384a997b02b8a7b422d613586f9403059c06f2"
    sha256 cellar: :any,                 x86_64_linux:      "27c26cc7c109e81c6ea0b4c7e7e13141cffaee79ba24cd13a20ca3adc3a11f66"
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
