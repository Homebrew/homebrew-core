class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://github.com/kenn-io/msgvault/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "a751a9d20b13cd23195deb1796e45f81ef5bf0742122f5d056321fb53f14fa03"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    manifest_sha256 "072735c7b30e8a2f50572cb6809da999381717aeec5059799f929194bf61bfce"
    sha256 cellar: :any, arm64_golden_gate: "7ce67b70112ac84a4950825dbd29e2efc1c39b27b45003e40fd1a3fa50b91b1d"
    sha256 cellar: :any, arm64_tahoe:       "05401f08158b718456190d56e2db958d7689f2b78df1997081bdd75d217387f4"
    sha256 cellar: :any, arm64_sequoia:     "f282becf993ba1afb9aad08c42f9cfb724e4e21fc31f3a7ae3994d9c820b72b8"
    sha256 cellar: :any, arm64_linux:       "04c73cb28cfa041f353b31c24371dbae78bdc9130d04c8e6041a4bb8be994d2a"
    sha256 cellar: :any, x86_64_linux:      "459480a2b94647efc3d3773f2b5179910175eb6567a3f8a2db4e3f8ec408e294"
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
