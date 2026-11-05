class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "3ce5f8dd339f17d26ce2fd8bf854e83df2a56a3836c41fd9e99145df48ba2cc4"
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
    sha256 cellar: :any, arm64_golden_gate: "4ebac6b23a05898602d055b7aa7c412f03d3308901242882a0b98cfba6fd6039"
    sha256 cellar: :any, arm64_tahoe:       "86dbed62e693d3f2f6a26170f284843f14bb2d22bad0d27078d78210d9af352c"
    sha256 cellar: :any, arm64_sequoia:     "dc9c745124ae824a4d370ead5a81459c791c1dff88100ca9c3cedc3a4b2c47c3"
    sha256 cellar: :any, arm64_linux:       "59f7a73a647fc25adc99d406c1c173105cdcb6af91eed7586809c4a21cea7d22"
    sha256 cellar: :any, x86_64_linux:      "76cd79e7d5c65605f135a2f260fb5ff2161e7588a3972088b2fb6ecb25c4c94a"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@79"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
