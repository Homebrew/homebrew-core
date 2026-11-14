class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.30.1.tar.gz"
  sha256 "256e67dc83959a7febb27388d0f9b1efcc51bae5e53db31cb9bf20f3cfb468d2"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0cac4dc9f03b282dbe1b28fc4cb5ca6ea13650f0fb39b4845eaff077752f49c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56bec5f9cd3e1d18bf2c6cda97fc0261b230ebf7ebdf39a48eb0b43d8c9db8a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6848f41925bb617200c4790851207e4e2fd3cfa4a7dd173b39e719232091afd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5251c9f02851b33714213824f06af496c154235e6e12fffdb9b537ab2f807ed3"
    sha256 cellar: :any,                 x86_64_linux:      "d907f01210188445f6932ee31ac4c49aebd737f5e39480e5b612439d39edc306"
  end

  depends_on "go" => :build

  conflicts_with "block-goose-cli", because: "both install `goose` binaries"

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
