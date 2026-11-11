class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "da316e6611d7294b603e76e9ea509ad837f18fc71c471afa6e511b5ede44a6bb"
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
    sha256 cellar: :any, arm64_golden_gate: "2340ac23a349041a0b6b926b42bc860ff0aa663b7cf90f678ce12b5c9a0253f7"
    sha256 cellar: :any, arm64_tahoe:       "50d3d68daeaca4afa071304690e689a05256e48b220b4b001a49ccc9cf616e00"
    sha256 cellar: :any, arm64_sequoia:     "d42f40a85604ec7ee097a6c67f4eea5dacc1feefe3af32c867bf6c5ce1938c14"
    sha256 cellar: :any, arm64_linux:       "927cea5e087523006de486f0f0ce3a021f5b65ebd52ffec97b4ffa1bbe6a9a6e"
    sha256 cellar: :any, x86_64_linux:      "c4b2904b7410e49c102f30afa8feb03954d50c6936bed54b6a08c77250d78fb2"
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
