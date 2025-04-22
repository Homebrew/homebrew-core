class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "a5b1398f95e9077d564dce9e58117fb6498493cd58957cce7287e476e60ff5a9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7c7e5f4f3ba86e91f1097dce0dde6351692a46e1a1eba89acb2f6bc59fc9dd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41807ac6bffb810a914f6e06d16b66377d70982ba188b38fca55a2938a9622da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d79a4f97a338f641e3ca74e7e0a261916395dd6bae02e7bf8beb151aa6f41de"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffe2eeabaa32e3efaff243f9cbb2eee222b7ac667f55560402c07bfce4de344c"
    sha256 cellar: :any_skip_relocation, ventura:       "925ccf5215a471f576eab34ef101a35a34857e4386060ae2a8d3636529a9f74e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61958e1f27480ec2e797c7f68aebb9bdbea3da3a06dc8225de7051e30cc395e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730d70eaf86b8a38b1c950424e12c11d34648c25a98b2e63fcf34ca49a4c41b3"
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
