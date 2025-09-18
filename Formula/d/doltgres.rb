class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.51.2.tar.gz"
  sha256 "d3532e9b3b08e2a79ade3c1d18e50aac7a5dc81c64989d97f8378a2594e5270c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "143d80493f297d32b643df30fcb48b3572331cc2867491a8e70d84084ce815b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76f6fabddb597e0ff45087bf2ccb12997ac50e7d5211cc6858aeccf3486c214c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c2245009878e46f5483b05a8940141061dec3d9e80c303836718ca13f9e546b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80c2481c4885e75643559fb77a228ff6ee7f3f75c311de02094e6dfc5772f618"
    sha256 cellar: :any_skip_relocation, sonoma:        "5045bfcd97884c9594afb92549e5f439f14b5063c79bb381c153f93a92376248"
    sha256 cellar: :any_skip_relocation, ventura:       "f92216bf27f8dd2c52f53e4e4c520eb1f710eb917832731ed2c9917646153ad3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc5389b31035a1ae18252f273bc243bec182c66badacb4398a43b5b7e30eee1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b14abde981802a9756405e575965643c3611abb52dc9cbd1d224476b6eaff6a"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

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
