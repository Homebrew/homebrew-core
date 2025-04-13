class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "645d1b9147d53d1670f9061ee42b0ed55bc2f3aff11f97ad8d324d6240a6d0be"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f506f4f234294a5e40f7cff03011d76497b9cf65dc2bbd8e39a51ea9e059b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "524d30b78ebff5f3c50fc5d300be1d7d62f0442a5069cb614736f4e2a1d00d71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e36292ac37bb42c3eac73e292f7edb0c8cc724d2a8a071a487a6fdbe970524b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb1d78bbd99cb84382ac4b5c854fef44eeb28ecb984df6377af5a9b0a3c4d148"
    sha256 cellar: :any_skip_relocation, ventura:       "1b5d7434ad53c72a3bcb698b97d53175870fffae44855e6066ad41a9f32b50a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9adedf9b3a650e26836019a59b5ebe2441485f66a64134b5a3d2c0f3894d3ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a082edd2db0f10b12b0dfe038978d77770b4fd857f2d9d575947b4cc36e4f05f"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
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
