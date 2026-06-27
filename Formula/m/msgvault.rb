class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://github.com/kenn-io/msgvault/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "6819ef21941d6f5c3c0150644fd6d41140662190f6a1cad6fc2da5cfe047af38"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "23918ae520ed53253c1c21012a780f98703c916136a7581f7da783253295e011"
    sha256 cellar: :any, arm64_sequoia: "8d564f12102405a49fae9d31e78db31f30ef302fe2036909f4c64645501003e0"
    sha256 cellar: :any, arm64_sonoma:  "79ed81cdfcb27bade7a15f2f5aa78f42c3992117a01e560bcd831be4ad7e3df5"
    sha256 cellar: :any, sonoma:        "d9b527fab25d4f0a845e055e3b04263344ea303b3830c5a9ca03875db432cbcc"
    sha256 cellar: :any, arm64_linux:   "4b2e6256d71706d5052f69222362b42b2b626300ad3b5ff0d7431ab1731cf57f"
    sha256 cellar: :any, x86_64_linux:  "2d9f3d3a1e5c9854c84adf58cdea6e63c2ec1160dec99ee289fa1bb7f620aa2f"
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
