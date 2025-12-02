class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.53.5.tar.gz"
  sha256 "b110006f5f6f9389bd1fde183fe04c9754e6862f6f0a27e4979046c85332c887"
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
    sha256 cellar: :any,                 arm64_tahoe:   "74d52ac6ad82903c06b742d61da1b4e3a4db7c1a2053156da0c254fb2de528fe"
    sha256 cellar: :any,                 arm64_sequoia: "766799f394f03492f2c12a2acc722e3e6a0bea00839935013304f20241c028cd"
    sha256 cellar: :any,                 arm64_sonoma:  "0a7e29d58e45b5e3350ae1012988be77d0ecc1d7788819a65df95fe5247eb5e0"
    sha256 cellar: :any,                 sonoma:        "d3b0070c8da7bbd49f65dee1ed84ef6be85939f4a1328f1ee1200aec9593af81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "560e19911c7dd30cd29090caf32c57d787891f31366afc35c26fc1610c2c77e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b16568da200097d752ae538cb1f3c5d02d48052146bc5b585d73b9bc744f9f1"
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

    fork do
      exec bin/"doltgres", "--config", testpath/"config.yaml"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end
