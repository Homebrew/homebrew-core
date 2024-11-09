class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "919e51955c33ae9a6f68d3919d9a3b6462db78d9056ac6b499a0f76f9ce70fc1"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22b1778645c99e3c853d677072a81d0923deff326ad6174ea93072a7b3575240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b77bdcdf75a0e9a0b48ae6311468c40c48cc035f54634e247d4019370109dd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72a14acb707fda8b59297dfefd373697e49987207dbad943e235cd6edd9a5c3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b7405695c31e03439bc32f1f122586afc99d91eced32f70e792a404274019a2"
    sha256 cellar: :any_skip_relocation, ventura:       "c3f22ce8e0cb3999fcb3ca2fec422ab32de0b5cee6bf252dccce7fbd61c43700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b2589179b6b011642591c44b6e539cc279c0a58b21d253c064588cffeefada5"
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

      user:
        name: "doltgres"
        password: "password"

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
    output = shell_output("#{psql} -h 127.0.0.1 -p #{port} -U doltgres -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n doltgres\n(1 row)", output
  end
end
