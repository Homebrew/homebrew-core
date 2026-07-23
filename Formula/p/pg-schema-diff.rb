class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "0e72b51bd7d2b9c7e31e6769f09d1beb63b13a996b66f65856fa5cafa15b0ac9"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbc2e1a95f37b92b89ef43f4415f80019ec42acdd8f78111555333a496b2f366"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbc2e1a95f37b92b89ef43f4415f80019ec42acdd8f78111555333a496b2f366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbc2e1a95f37b92b89ef43f4415f80019ec42acdd8f78111555333a496b2f366"
    sha256 cellar: :any_skip_relocation, sonoma:        "367dd34d87eb8124feef1f1b1d8edbf76892c944aad6568f64b747b45060df48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbef7f0d93e7afaff0e31064c8ca8643e18c905d341e9ec8a9d9480957071d89"
    sha256 cellar: :any,                 x86_64_linux:  "8ae7af7cae7834e28cc7d45a5ba2f438efaad5eb844d213090999661e08ed785"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pg-schema-diff"

    generate_completions_from_executable(bin/"pg-schema-diff", shell_parameter_format: :cobra)
  end

  test do
    pg_port = free_port
    dsn = "postgres://postgres:postgres@127.0.0.1:#{pg_port}/postgres?sslmode=disable"

    output = shell_output("#{bin}/pg-schema-diff plan --from-dsn '#{dsn}' --to-dir #{testpath} 2>&1", 1)
    assert_match "Error: creating temp db factory", output
  end
end
