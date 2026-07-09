class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.56.9.tar.gz"
  sha256 "5157c5225712361e2981e9b8ca59dc9e410766e5c1ef0d2bcd29af0883742c4a"
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
    sha256 cellar: :any, arm64_tahoe:   "356148d43b771db684d8f356bee26dd890d88229425a49670bc35a5952e69153"
    sha256 cellar: :any, arm64_sequoia: "4b75210c04d9e0042c025d8a264a153907cccccc60afa5bc707e89467f335c5b"
    sha256 cellar: :any, arm64_sonoma:  "6fbdc3f39092920bb5efb2c5a4a4680c5591b9470dfee1d392a04b138cbb5ba6"
    sha256 cellar: :any, sonoma:        "fe618f01c11f644b5ef8f9bb4f9909430c2c67273e41b22d8f514a8766c13192"
    sha256 cellar: :any, arm64_linux:   "fb17abd4cc25c45421ba619fe7ae67126c4f4b6ac39032df0044c1428ca44845"
    sha256 cellar: :any, x86_64_linux:  "ce636a7bf1e285f29ae12a6228b3ab9796e42d6c89549e233135d8d58a00be86"
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
