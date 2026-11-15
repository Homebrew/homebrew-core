class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://github.com/kenn-io/msgvault/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "be0b82d9e6a75bd35c9a99cfb268b60f5e1b9911dfb5538467e1b3d0b6ac5be0"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9faea5bd577543da802ae7ab7a87ad0969b2e51de7c4b2b5720180fae9bb1915"
    sha256 cellar: :any, arm64_tahoe:       "305a6a571e18977ef0c3a096ae08503341253a9d6690f0614262feb28a972bc6"
    sha256 cellar: :any, arm64_sequoia:     "608e25ed6b4fca3682da0a328dd9a1de04f8db76da8fb4588c27b5eff79a3a74"
    sha256 cellar: :any, arm64_linux:       "32b449e56fbcfb4c8a257471f7e414449547dbfe2d491bf5baeb153794488bcb"
    sha256 cellar: :any, x86_64_linux:      "a37a4d7d78a3a24fda797314888620b501084de218142eb39a90d1d1fc56eedd"
  end

  depends_on "bun" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "duckdb"

  uses_from_macos "sqlite" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    system "make", "web-install"
  end

  def install
    system "make", "web-embed"

    ENV["CGO_ENABLED"] = "1"
    # DuckDB is linked dynamically against this formula via the duckdb_use_lib
    # tag, rather than the duckdb-go bindings' vendored static library.
    ENV.append "CGO_LDFLAGS", "-L#{formula_opt_lib("duckdb")}"
    # sqlite-vec's CGo binding #includes <sqlite3.h>; macOS provides it in the
    # SDK, while Linux needs Homebrew's sqlite headers.
    ENV.append "CGO_CFLAGS", "-I#{formula_opt_include("sqlite")}" if OS.linux?

    ldflags = "-X go.kenn.io/msgvault/cmd/msgvault/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: "fts5 sqlite_vec duckdb_use_lib"), "./cmd/msgvault"
  end

  test do
    ENV["MSGVAULT_HOME"] = testpath
    port = free_port
    (testpath/"config.toml").write <<~TOML
      [server]
      api_port = #{port}
    TOML

    system bin/"msgvault", "init-db"
    assert_path_exists testpath/"msgvault.db"
    assert_match "<title>msgvault</title>", shell_output("curl --fail --silent http://127.0.0.1:#{port}/")

    # Build the analytics cache, which runs DuckDB's Parquet ETL over the (empty)
    # database and so exercises the dynamically linked libduckdb.
    system bin/"msgvault", "build-cache"

    assert_match(/Messages:\s+0/, shell_output("#{bin}/msgvault stats"))
  ensure
    system bin/"msgvault", "daemon", "stop"
  end
end
