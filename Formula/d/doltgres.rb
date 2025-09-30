class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "ee8c09c7d32ce3bba2d62f073616e199e7e909cb133f679a68aaa8fff717c6f5"
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
    sha256 cellar: :any,                 arm64_tahoe:   "5605fc0d42953f470d607832e3e7541c1c7a0e986daad726ed515ff706f13c02"
    sha256 cellar: :any,                 arm64_sequoia: "c43674519592e5d220dbb427b550fe157c8fdccebd926fe60042dd74a9e9725d"
    sha256 cellar: :any,                 arm64_sonoma:  "b9a2a36d28693e8c775f5c1e0516303b5bf0182c6b30452882e60c41021254fe"
    sha256 cellar: :any,                 sonoma:        "129a3f9ac749ff1b13a482a53153d97882580046ae42a3fa0c88032962865a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc4005c1a69acc8d3702f1b876bb4e80be1c911c076f8058171dd2c6fe26d7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77951a3e53d90bd8372afeb164feae9e5f31b3fd0f47c48fe070e2ee1229d0b2"
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
