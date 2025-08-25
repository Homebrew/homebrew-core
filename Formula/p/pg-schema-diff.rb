class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "38fae5ae53d8199b14ecc7eccf436cd138936a87bcb75aaa9968ba20d1d3dd1f"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pg-schema-diff"

    generate_completions_from_executable(bin/"pg-schema-diff", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    schema_dir = testpath/"schema"
    (schema_dir/"schema.sql").write <<~SQL
      CREATE TABLE public.foobar (
        id serial PRIMARY KEY,
        message text,
        created_at timestamptz
      );
      CREATE INDEX message_idx ON public.foobar (message, created_at);
    SQL

    pg_port = free_port
    dsn = "postgres://postgres:postgres@127.0.0.1:#{pg_port}/postgres?sslmode=disable"

    output = shell_output("#{bin}/pg-schema-diff plan --from-dsn '#{dsn}' --to-dir #{schema_dir} 2>&1", 1)
    assert_match "Error: creating temp db factory", output
  end
end
