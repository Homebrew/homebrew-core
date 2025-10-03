class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "a5cff2a9788ecb3f4f40237065893925239c6a119f56320b08e95ae5d91b9cc8"
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
    sha256 cellar: :any,                 arm64_tahoe:   "f19d1815dea71fdcb28354065880ce5da6061648030e88e0da5696f21edcddfa"
    sha256 cellar: :any,                 arm64_sequoia: "2272f907cefe6b7faa8391af263f196e0d58be48971042b3f4a5830c9198f4a3"
    sha256 cellar: :any,                 arm64_sonoma:  "4d3bfc6bfeddf9887fc39e6cbd5fb7fb638c8451ffdb1e9321d70034eaf3c789"
    sha256 cellar: :any,                 sonoma:        "bed94ea929da21a090d12ffbc417055388e83962494cce7372a8535efc7fd85a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e144148b05c3bb7900fd688afac631236184145733c6398f97d20757d30530e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14dad9b5f033cb9d669acc6d900ca8933056096d96a47cef5ed8bbcae443c1ca"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@77"

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
