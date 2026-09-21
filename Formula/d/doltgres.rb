class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "85490227eff5f17afc740f99ac21cb1a9181085d43fb2744692a60409c2a2eca"
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
    sha256 cellar: :any, arm64_golden_gate: "27e6c8bc57093136ed9e7e681e74475fce9ed7d20c5aefebbcb6ac12e23727db"
    sha256 cellar: :any, arm64_tahoe:       "997928dc3444d1699fb8f81b9aff5efd4ad86cd0d271571ba513d16dba0748a7"
    sha256 cellar: :any, arm64_sequoia:     "554fe870ac77099669aca1f19518d7199e6017fe7fef8d804ba2bcdf295659af"
    sha256 cellar: :any, arm64_linux:       "7ca416b0de06475cdc2330a890458304dbff0b48335903b4fe21ae86ab439e92"
    sha256 cellar: :any, x86_64_linux:      "d718dcf8558f07b3ea047623519b2a7ffef83daf7385bf627366cf372836413a"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@78"

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
