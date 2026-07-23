class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "7b7a74280d108c8fdbbb074f348a358ad7170d329b025f8a0b62065dcdb2915c"
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
    sha256 cellar: :any, arm64_tahoe:   "d70ea6aede9dde6a0d7db0bfae5c0adc637ecc3a4ee41454f961f4d240ece94a"
    sha256 cellar: :any, arm64_sequoia: "4e34a7b02ea5c5072c47ff4451fb7f2c7af661a46651cf8e9696302d48c9168d"
    sha256 cellar: :any, arm64_sonoma:  "0e2cea3cb2010a502ada171cd26d5b7472d81b49a469e0165e0cfc7e218fd609"
    sha256 cellar: :any, sonoma:        "0f8ddad57fbb8694aa79aa388d45a1883f1e126973e9a185384e1705d89f7beb"
    sha256 cellar: :any, arm64_linux:   "f5bf1058d664871470bd8378872452f6d80f284135b535e19a28ad0dac9117c3"
    sha256 cellar: :any, x86_64_linux:  "7f9a28e3305c69f9e10c7d24eed229f7e801d0ab5a79edb196d9b89629f133c7"
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

    spawn bin/"doltgres", "--config", testpath/"config.yaml"
    sleep 5

    psql = formula_opt_bin("libpq")/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end
