class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "d2a3b96a6b6a0f44d95f89371727b7da378fcd446f74c81daae7c52ea1bba2a3"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "784fa9e3ac1ab2f09b3fa89c0da92cbfb6655f3b15e6ad8f879396a283a63348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c81fd3f2431912fb59fc3d4435d3ea5f8433eb1c80b7717dac8e446f1127f46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ffccfbf8bbcb288f3846dabbe140eb64499dc4ec117507a5191fc36aa2a2382"
    sha256 cellar: :any_skip_relocation, sonoma:        "942f8a6bac5fa1a900042067954318c1a744a55e9cf790a6b30af302e14951ab"
    sha256 cellar: :any_skip_relocation, ventura:       "4ac3b95b24a88d4ebb6b69872eb6e81a09427f82a4488cb1e5cda85c7ff65437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52f1afc798fa7e0ecfbd6cadfc4a32142ddfc9ce14089518c120ab7288a3f89c"
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
