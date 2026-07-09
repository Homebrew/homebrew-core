class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://github.com/kenn-io/msgvault/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ffadb982007edb77c48942d5c14798f20840862bf39f905e256db176ff3d221b"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "43ef6a2e024f5181252a97a2eac7e759fd1c351bbe5ad59e8b7b1e9b8ce67461"
    sha256 cellar: :any, arm64_sequoia: "0ee22837790444b969b18ccc3ed58b4ebd5c1ab1b241baebb08350236a722916"
    sha256 cellar: :any, arm64_sonoma:  "3d437f70f9fca35ece840502b3bcb03894fbc18def6ed9dee27184f55fbfae14"
    sha256 cellar: :any, sonoma:        "915b709d1b3f8f0435691e34b1e088dc1a508c056c5e7fc7d319f19bafadd406"
    sha256 cellar: :any, arm64_linux:   "66ac1c6a4222a38f32d740c21a872d93538da20d22237d1b93d46595f70ff660"
    sha256 cellar: :any, x86_64_linux:  "956b255d364e83f3ed1c96eb01a6fb6d99f157f24c901db0694ea98bc7a20570"
  end

  depends_on "go" => :build
  depends_on "duckdb"

  uses_from_macos "sqlite" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    # DuckDB is linked dynamically against this formula via the duckdb_use_lib
    # tag, rather than the duckdb-go bindings' vendored static library.
    ENV.append "CGO_LDFLAGS", "-L#{formula_opt_lib("duckdb")}"
    # sqlite-vec's CGo binding #includes <sqlite3.h>; macOS provides it in the
    # SDK, while Linux needs Homebrew's sqlite headers.
    ENV.append "CGO_CFLAGS", "-I#{formula_opt_include("sqlite")}" if OS.linux?

    ldflags = "-s -w -X go.kenn.io/msgvault/cmd/msgvault/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: "fts5 sqlite_vec duckdb_use_lib"), "./cmd/msgvault"
  end

  test do
    ENV["MSGVAULT_HOME"] = testpath

    system bin/"msgvault", "init-db"
    assert_path_exists testpath/"msgvault.db"

    # Build the analytics cache, which runs DuckDB's Parquet ETL over the (empty)
    # database and so exercises the dynamically linked libduckdb.
    system bin/"msgvault", "build-cache"

    assert_match(/Messages:\s+0/, shell_output("#{bin}/msgvault stats"))
  end
end
