class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "056e88ea936cb121ab5461932a40dd1b88fe06749e42b9443988b83f05fb6a17"
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
    manifest_sha256 "a419c298f80eb38158ebdc3b5e30ddfa5ff1d82cf5f1ea6fa1bda4f7c555c655"
    sha256 cellar: :any, arm64_golden_gate: "b144fb6e1e1800d9b3567ee5f5a26f9a66bc9e8585abac5a668ff74abdcb1ab7"
    sha256 cellar: :any, arm64_tahoe:       "149c04acae591b3a9754f708687f68e826d21e09b4f6e3fc7a31a3ba3fc0e909"
    sha256 cellar: :any, arm64_sequoia:     "e6e9f04e61b7bf370f074502cb8737ff6b23375472de64ea75cb99d4ee6913a7"
    sha256 cellar: :any, arm64_linux:       "9c6e78d36dbd66c20603add2b7f320b0cab6e1ab7dc8266ef4b0b4658aba9453"
    sha256 cellar: :any, x86_64_linux:      "c12af6e55bcee88ad5339ef827966b850bf78e5cef06fd1512d2972fceb737a9"
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
