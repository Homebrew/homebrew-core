class Msgvault < Formula
  desc "Archive a lifetime of email and chat with offline search and analytics"
  homepage "https://github.com/kenn-io/msgvault"
  url "https://github.com/kenn-io/msgvault/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "2aa8dc6c3228acb8d94920714fe32617dfd85dc6d02d3aa9c0d511df9e330401"
  license "MIT"
  head "https://github.com/kenn-io/msgvault.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2b7bc4fa9802ce4afaa14a7741ed3b8963cf2dd4ddb219bfec9bb98966bcaca4"
    sha256 cellar: :any, arm64_sequoia: "18d799c24f15051bf52780f891dd61608dbb46ca5ddfe6618f96d4e0096938da"
    sha256 cellar: :any, arm64_sonoma:  "caef7d82dbac2caddb1a7fd47529d9334096dc1801ad1d70c68fc24e04397a51"
    sha256 cellar: :any, sonoma:        "650b911af7f0f0153b5817cb50fca1f2fc405430c8f5402a7a3377367e29a242"
    sha256 cellar: :any, arm64_linux:   "f7e7d23c99a68bfc73e07b913a3489ce69d89ec35020b72389334ce662d5468d"
    sha256 cellar: :any, x86_64_linux:  "e612f94d976567fb03d614baf1cb5a80de80f9576f1af3d7fdf46e0e7ad0425e"
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

    ldflags = "-X go.kenn.io/msgvault/cmd/msgvault/cmd.Version=#{version}"
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
