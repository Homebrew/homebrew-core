class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "203619e794338e15ddc65e6bb5f9de817b881e03518289eb029ef866d3babc52"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce562e873fafe35ea9c104c0d30366a916b01c315d0a53e7e22a48666babb20d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce562e873fafe35ea9c104c0d30366a916b01c315d0a53e7e22a48666babb20d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce562e873fafe35ea9c104c0d30366a916b01c315d0a53e7e22a48666babb20d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a357fe43e6cccb582d451a420d774a5317223d2d583c312e903e94c86a351428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eda75ea6c5b0b62c8fdc9ccade5faf1991f217d7cd61d02010d433b862b7af99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc47dac60204e4dcd0f0af5db2f253b7d40cd74d29ce27fbe55301250b3dd305"
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
