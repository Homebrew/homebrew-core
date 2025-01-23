class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "41ece478271d8ded753ed8b7ad9c4ee17af874129d2616ce006044ddc7b5df00"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "696e57f4aabd095d4d1ed98d1df29e62dfa9c822c4e0a40ae89a658b1db57b21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bbb373a0c93b4495e9e278a7eaa7792d296df9885d21d68a5a02cf4c81b4e4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0973ae70957d6ea2cf6f75fd4b5ca84189346786897aac149e1b5e8a4f90c1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "848b8a91badcedd1e247f61b003bce2435bd9edd842f15a78dde54ee97a39baa"
    sha256 cellar: :any_skip_relocation, ventura:       "60e2de6c325beddc8970847320c90d67a0c6506edda9eb3a4bbe40fa13ca45a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c7e95b04874d28ac818ad197076098697813a194ee502cc5d5028cc1acca57"
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
