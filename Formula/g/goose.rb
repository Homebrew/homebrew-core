class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.30.2.tar.gz"
  sha256 "9a79b2a4c93cb9ee2de4dd30cf9fbe9d8d9ac57c851c3105b4a0bebcdd7ea875"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    manifest_sha256 "3582c2aa86dc0f1b51dc0a02540cd2026b6df6d07ed5687004548e4f90c327b3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e37aea8d73b047755dc4632d189a6a69e0e64b4d6279b1121b6ac4db2a9e88d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c468414c308f6a424dddb372d5a319b5bb62e7d0101bf64a38dd7ee67ce1b3b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54ebe85c99de68579ab2fe8a8c328501b1d43a139eab6151db413c47a62b0189"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "467c5b22dbe408498c89c9e009d6742bdc6e482cc039d8059c3915c86b889e10"
    sha256 cellar: :any,                 x86_64_linux:      "236c3e72d8ac07926fda403a9cb51bd087818b61606eff8c91b9d67858a0c980"
  end

  depends_on "go" => :build

  conflicts_with "block-goose-cli", "goose-lang", because: "both install `goose` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
