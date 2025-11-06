class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.52.4.tar.gz"
  sha256 "869c18fc65289318034fc3e282802fe5262306230560d7a192401570cfb10854"
  license "Apache-2.0"
  revision 1
  head "https://github.com/dolthub/doltgresql.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0942adebe5c1ba679c99136371cec3b3b1a7a48546ea857ba1e0fb9fcce900ed"
    sha256 cellar: :any,                 arm64_sequoia: "68d9fae1a9dbffd4ec9a178040eeeffd08de5e0dfa48e71f9aad02ec11ad77bc"
    sha256 cellar: :any,                 arm64_sonoma:  "b04984641dd3def1a82ae49f66c330d4c9089c4f81dfaf2f70b48514efbc200c"
    sha256 cellar: :any,                 sonoma:        "3562c6dbc2b28f452a16d8ca97787b566f77d4b4edf286e49cc12eb33fe2937b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b1e04d6b897703b1827667307b30df1f4e13972baf05ab0abf93d04c00416b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494fa5e5e7792d8468b86994426a791c4c77610b4f49ea4d1cf5e0a221f7f6f5"
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
