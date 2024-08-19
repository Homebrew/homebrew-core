class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "2bea894c360d40e5744e9e4c2251d23efb3b51edc36e1f065e11c7a392462bf5"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50f7da1cbca3d207af1ae6506d8aa487732495c03e6389ab83d7269992e41fd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a9b9df7b13a9f3b85afba7bf6f4f8b8ad6cfed84793dedee98f5cb127dba124"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc7538113b869a07093b93de6d2f55fc86f05038326e9c2304449fc0018eca3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "acbcf0c317f561a3f5894b512ce62278d9d016fd95910eb0467adf0197ba82dc"
    sha256 cellar: :any_skip_relocation, ventura:        "e1ec8e3145d763734f62cee6d3a9cad7051e8e52070c0601006485a2bd21c882"
    sha256 cellar: :any_skip_relocation, monterey:       "75a3600786fd7258c0d0ed9574271a3459c89ce0e9dc032b30953aea455d1e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "176c94821d115e5ed4391c549c508030b8d610acaaf29e3b32f7004f43f19716"
  end

  depends_on "go" => :build
  depends_on "libpq" => :test

  def install
    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/doltgres"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~EOS
      behavior:
        read_only: false
        disable_client_multi_statements: false
        dolt_transaction_commit: false

      user:
        name: "doltgres"
        password: "password"

      listener:
        host: localhost
        port: #{port}
        read_timeout_millis: 28800000
        write_timeout_millis: 28800000
    EOS

    fork do
      exec bin/"doltgres", "--config", testpath/"config.yaml"
    end
    sleep 5

    psql = Formula["libpq"].opt_bin/"psql"
    output = shell_output("#{psql} -h 127.0.0.1 -p #{port} -U doltgres -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n doltgres\n(1 row)", output
  end
end
