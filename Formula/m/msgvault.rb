class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://github.com/kenn-io/msgvault/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "2f819b889e6968afd18646d78f7c3a0975d1fda51e53fc96e8d69a705b910530"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ef35b4d073d3cda710cf12d1c719a74d0f6295612b57b6a68c7959e42f1e7857"
    sha256 cellar: :any, arm64_tahoe:       "9dae884f61eddf2a02049318d7a0cd5d88bd9ea94603e61c44e4530f7d18af6e"
    sha256 cellar: :any, arm64_sequoia:     "afc931ff3a694c73f5bd5e6cea7e94dc171ad54870fae6e214dd36417168761c"
    sha256 cellar: :any, arm64_linux:       "8a80802b68cde67e139beb16f12a4b6317e5fa34890691cdea3ee06519b2019b"
    sha256 cellar: :any, x86_64_linux:      "6d06be527853d7ba1f7c8c93a2ab43064825fb1cad17bddcedad46a96d9c38c1"
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
