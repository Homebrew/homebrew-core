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
    sha256 cellar: :any,                 arm64_tahoe:   "62a234760bb44b2170d406a852edf37d512eafb257cc482e83ceb0f9aec25311"
    sha256 cellar: :any,                 arm64_sequoia: "e4a7bb60de5377d0753ef3ca2caf3bff2bcb6c1d380f9c7d4b62a9ad8c453860"
    sha256 cellar: :any,                 arm64_sonoma:  "c5429810cd75469506d9ade512b98b47c9a3caceef7cf132190549b283fce3be"
    sha256 cellar: :any,                 sonoma:        "ecf3b7058214d55f4f1dcf26464cf540f53e904679f3cdc5eca5a79dbcb685e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0a5089fbf97b4e95c6c22d527c5f4f22447d9ed4eb22e2fc855ec673a03ada4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6311b11bc096cb31a6364ec19be754e1129970b0c873ac80ac52b3d68a5cc440"
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
