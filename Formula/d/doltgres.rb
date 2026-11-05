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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "cfae1e514a493b3ddd9d9e0cb46413ad14c1fd62f20b78a8b70d78d2e1869680"
    sha256 cellar: :any, arm64_tahoe:       "1561ecbc8457474e1d2bc0e39bbaf3ec748ff1bed1bae164ab91d28f77977698"
    sha256 cellar: :any, arm64_sequoia:     "e55faad385e2755cbf25d98c21b6b626e3bb4bcad2c0ccefe2362d7833a11693"
    sha256 cellar: :any, arm64_linux:       "adfeb5535e6275dae55f5e38be381b7dfde1eb1c1236d5b0524b97dc693ad24b"
    sha256 cellar: :any, x86_64_linux:      "97b0b9e26add26cf357d714b8078932edd8c3385125ea65e76a545adf6809e16"
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
