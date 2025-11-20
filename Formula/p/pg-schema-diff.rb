class PgSchemaDiff < Formula
  desc "Diff Postgres schemas and generating SQL migrations"
  homepage "https://github.com/stripe/pg-schema-diff"
  url "https://github.com/stripe/pg-schema-diff/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "036abefc48a7c4b3fe73f8ab659f7d3f3379d85b3747cd2ceb973ae542192667"
  license "MIT"
  head "https://github.com/stripe/pg-schema-diff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7b9f07306b17afb7b12fa45a249b678a07150517c971b36cb110b2bf02f45d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b98ed4ac4b75b8b959780a011c8b4fa6399267222bd2756a0d8989e249b2677"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b98ed4ac4b75b8b959780a011c8b4fa6399267222bd2756a0d8989e249b2677"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b98ed4ac4b75b8b959780a011c8b4fa6399267222bd2756a0d8989e249b2677"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbe23212edff4718890067907cad83d7cd8ae4c7fc53be464e1319c1c5d35a29"
    sha256 cellar: :any_skip_relocation, ventura:       "bbe23212edff4718890067907cad83d7cd8ae4c7fc53be464e1319c1c5d35a29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52287a45b152a43d11d6f60375c3f3b31c5f8551f253f418f2045adb711f80fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "761c21b121914bd68e6e972d000f26cc08e809348945b48c467dbb51f6b9189e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pg-schema-diff"

    generate_completions_from_executable(bin/"pg-schema-diff", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    pg_port = free_port
    dsn = "postgres://postgres:postgres@127.0.0.1:#{pg_port}/postgres?sslmode=disable"

    output = shell_output("#{bin}/pg-schema-diff plan --from-dsn '#{dsn}' --to-dir #{testpath} 2>&1", 1)
    assert_match "Error: creating temp db factory", output
  end
end
