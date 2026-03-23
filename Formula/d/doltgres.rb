class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.55.6.tar.gz"
  sha256 "df10b9c059a045d889e8d9ddebd278977e07e9e26aac9067714dacd448eb07e2"
  license "Apache-2.0"
  head "https://github.com/dolthub/doltgresql.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99f5908b2b56f89c36ca447f8aff3a0b3098105f161c0f023ed2fbb0f586e55e"
    sha256 cellar: :any,                 arm64_sequoia: "037d7ccf4885c07af38af1adefdb3253b1bd687c7bf895cd4559feeb5fd61158"
    sha256 cellar: :any,                 arm64_sonoma:  "817a3581d98b434ca2b86d0bb5a2453a9aae52328cd7cd8a14aa518767e8b1a2"
    sha256 cellar: :any,                 sonoma:        "f3021c8548e1cd1c18e6af745eb15dfbf392670a56da4a569c5714939221454c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04559101dd058217e12c0c4569d34818d71ff1ec0a8aa5c10a7db8c834707f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1e59d0052c659b2bff56ab78e6c8870c876d126b6c77d32b6687d7480ffe95"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/doltgres"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~YAML
      log_level: debug

      behavior:
        read_only: false
        disable_client_multi_statements: false
        dolt_transaction_commit: false

      listener:
        host: localhost
        port: #{port}
        read_timeout_millis: 28800000
        write_timeout_millis: 28800000
    YAML

    spawn bin/"doltgres", "--config", testpath/"config.yaml"
    sleep 5

    psql = Formula["libpq"].opt_bin/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end
