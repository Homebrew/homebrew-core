class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://github.com/kenn-io/msgvault/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "100629f06329757b8626de34572e610eacee4e06e1c0f59c823298354944ec53"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b1e19edcd4444bbe58683a9224cfb63f15d3ae1b017ce6e4359e39a83cc5c255"
    sha256 cellar: :any, arm64_tahoe:       "51ec05ac5d494c891bf4e133693d9b93e86adce88795b94de608c5d401af1de0"
    sha256 cellar: :any, arm64_sequoia:     "8afc67b4b590a9e461a8c0c67c8ac0a71652fa6d6d5358bb9f077b936467b3e2"
    sha256 cellar: :any, arm64_linux:       "4c15c6a633382f4505195ce3c5bb6bfddcbaf09a8c19d7cab0b510a9b05dde31"
    sha256 cellar: :any, x86_64_linux:      "289f95161541e981b730ff5157b673f9a51eb5eb2876a5f8d018063f4ca0fb9e"
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
