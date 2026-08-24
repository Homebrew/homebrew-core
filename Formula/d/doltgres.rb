class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "755748cbbe79b75faf7bb0a5fd009e0e5c243583a0f075d12ff3ee66655b708b"
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
    sha256 cellar: :any, arm64_tahoe:   "6a49f6cfab70ec461705842b8836c5ecde695525050a81f9b230d8baf29fb069"
    sha256 cellar: :any, arm64_sequoia: "fbe03d5f5a1c51c9943435a0022377bf20ba1df7a560474439295a17d4da655a"
    sha256 cellar: :any, arm64_sonoma:  "4f9fcfe78c8595ca71da0587cea9a2b2e37198380de1ba2284a3c31a3e635c1b"
    sha256 cellar: :any, sonoma:        "928f7d39f6c8c8e313032ea1ff2fc892b21a82a520b1f8ff5974fc813be64482"
    sha256 cellar: :any, arm64_linux:   "717b28f1a6132ce89873855892a398152aa715959d29f9faa5b95594a6a9256c"
    sha256 cellar: :any, x86_64_linux:  "28597ac0cc0f119530574cc70c8da791c5b2cc490bbdf6698a0ee93fc69d9856"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args, "./cmd/doltgres"
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

    psql = formula_opt_bin("libpq")/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end
