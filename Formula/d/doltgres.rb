class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.52.3.tar.gz"
  sha256 "6845271979c18e05061329faf4bcc9c4aa61d095cb53722fcefe516ccc0b1289"
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
    sha256 cellar: :any,                 arm64_tahoe:   "98d9fa8933a8aaeb93d15de1edd3169296c8ab462ab810d3b60cfeab9bf277e3"
    sha256 cellar: :any,                 arm64_sequoia: "86ee7198da58e7b0b586076e959ee1fd1638669e9aa83ceae9991f5dff09936b"
    sha256 cellar: :any,                 arm64_sonoma:  "ea758c1e0f018dd6ba69a5f939df985a7f94c008dd1b8454ae4dcb4bb9acf8c5"
    sha256 cellar: :any,                 sonoma:        "0954180522e88590d1c78c96af6e990fa8c49f97195238defa4e09157568aacd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b0631268877684549751a886cda3ac1d59e7331158dcb2ecf7405de2a639ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6b3bcf824b50b4743f321b99a45718aa2c40e09d27749f14c02e8c418a9c824"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test
  depends_on "icu4c@77"

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
