class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.55.3.tar.gz"
  sha256 "4d33955dbd80adc7ad2aedca7de7579a50307dad3b1a08d424ad04cd6d0ce13a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "b9c17a7fd96c1bb9cf756ed266f768cbda8af077bfa6c05b69d608110ab9d2d6"
    sha256 cellar: :any,                 arm64_sequoia: "d70551f2c9bf66f982315550ea7b02f056e6496671af1e9e916af0dbf6bf57e2"
    sha256 cellar: :any,                 arm64_sonoma:  "d4e35752bfe2f7ad3da27d1c4e8148c3971f0d87b167cc7add0afcbea9887bf7"
    sha256 cellar: :any,                 sonoma:        "4c19ef563d411ce341ffdce299cc406b9aee102742e8f3a05b38d122da58f6b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c51b5fdbf89fc379e7ef38807a3d5c519bea7abbba8c84ca0d4c854d4f7b5950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17e2e1661b41419523c1f980d43b9c44c34f7e8e0be1a2fc2fd913d1535c4c6b"
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

    psql = Formula["libpq"].opt_bin/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end
