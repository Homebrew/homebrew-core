class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "b3c81115483ef8d630bd5bc80663614c4748946443c8b5da80c9462aaf9b98ae"
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
    sha256 cellar: :any, arm64_tahoe:   "1d47500c5028392fdf6d40389634358161384786672a5553db22db36c4e9d4d0"
    sha256 cellar: :any, arm64_sequoia: "63eca7e746a5a71db3640987464a242b4f77309f118160ea55dd1c1928cf086e"
    sha256 cellar: :any, arm64_sonoma:  "bfb16240ef2dcfeb863b0d9fda72c90918719fc2be6439a24073e9ce1905c52a"
    sha256 cellar: :any, arm64_linux:   "839e923f491929ce420541eae260b233b3709842c3f6addb1287256bf4dc4963"
    sha256 cellar: :any, x86_64_linux:  "0867df34448fe195c280bdd9c9cb78062dcaa97ed596a5fc8afe25cbd4020af4"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@78"

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
