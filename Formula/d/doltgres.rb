class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "886099d2452a56dab656423d5c62130489bf333ff714788b4f131d10f5442618"
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
    sha256 cellar: :any, arm64_golden_gate: "9a3fb3c1cda41abb79e014d4040c1b6f88f9bcfa821c65e11e3163abbc0eddd2"
    sha256 cellar: :any, arm64_tahoe:       "1b41aa38476f1d5034b0137cb12982ef44d342b3e7b1be0e5399c29a3f3462fc"
    sha256 cellar: :any, arm64_sequoia:     "07bc6a527dea8468f43f17e2da179a0f334ac8d49124b42cc5443fbf4f62c338"
    sha256 cellar: :any, arm64_linux:       "1393173d7bb2d721776be0a2fb3b3b36a4723aa2ed3dd53eb32df4e2e6ad4c63"
    sha256 cellar: :any, x86_64_linux:      "e818f4bcc8a90c09eb3da7e22f86cc509e24ed15d58bc4ea0f2b3f4e57241b34"
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
