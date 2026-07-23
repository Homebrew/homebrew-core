class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://github.com/kenn-io/msgvault/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "6c3539d69de1b1856df84fd6bee782418cf4dd9c0e0140765bc0d30231360740"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "157c5d0edc0bb1813baf9e6cadd1f212ba4af15c675633b184cc7d6c0c9f5b20"
    sha256 cellar: :any, arm64_sequoia: "05b86147d0607f36412891a856acd42bb8e7edcb18fd6c33017cec2e2faf7b2f"
    sha256 cellar: :any, arm64_sonoma:  "8b4d06d22dc3c73a612a56bae90db938032963ce417d61f4430be48848fa8958"
    sha256 cellar: :any, sonoma:        "4c61c6646f98731be69e7f1ed2873ab933606ea24b41f034d9429552ae07836a"
    sha256 cellar: :any, arm64_linux:   "4029e2b079af95e90d402851eb6f36e3828850d9d3f820dfb8e887e34d84196d"
    sha256 cellar: :any, x86_64_linux:  "39b05d406ee55f6425221d853b64ce760832a9a94605435211058ff6be9faafc"
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
