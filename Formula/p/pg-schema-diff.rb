class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "70b978ee7256fb8693cbc205f749691e4f403f1ed760d619d623f76bfbb138a6"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b19fb80ab55dba821ac2bb1e298b124a5606f91eb5648feebfc2c6d1738c3314"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b19fb80ab55dba821ac2bb1e298b124a5606f91eb5648feebfc2c6d1738c3314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b19fb80ab55dba821ac2bb1e298b124a5606f91eb5648feebfc2c6d1738c3314"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee0ceb6ccc7c40ab1e9a66f6673e8a2407b461577996daa85244366b2b6381df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ac834d57afeaf10601960c32e9f9030dc042d31126c601ad68de372aa73299e"
    sha256 cellar: :any,                 x86_64_linux:  "e9b30f5a5aa37d6a88e6b868e266a16c1486db33e24041a645c914af8ed42ef6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/pg-schema-diff"

    generate_completions_from_executable(bin/"pg-schema-diff", shell_parameter_format: :cobra)
  end

  test do
    pg_port = free_port
    dsn = "postgres://postgres:postgres@127.0.0.1:#{pg_port}/postgres?sslmode=disable"

    output = shell_output("#{bin}/pg-schema-diff plan --from-dsn '#{dsn}' --to-dir #{testpath} 2>&1", 1)
    assert_match "Error: creating temp db factory", output
  end
end
