class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.56.2.tar.gz"
  sha256 "72dcc5bdf6f60aa5f356c40cd1486b628f5578e4d687ee6efa14f75f78949174"
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
    sha256 cellar: :any,                 arm64_tahoe:   "83743490d7293ec626e1c9414d3bd07fa758f5f264e7e259eebd1b5d11da3d0f"
    sha256 cellar: :any,                 arm64_sequoia: "bef9a7162bc9f645513945b97c88e8462fa4b030b2a0c432aed55553f9d4c7e1"
    sha256 cellar: :any,                 arm64_sonoma:  "643d39afeccdbe594eb83efc847343d2cebb4f8859733b042e4444de51501877"
    sha256 cellar: :any,                 sonoma:        "c562ecc7ca5487912915bda7d1582935251a1306e985e0be4545d822f77e229f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4129799a002fc5e0bbd40d6978060b914faf36c88e2f177a57cf7a3a404f16ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b75c94c293b45f71da355ee08099c6ebb1150c5695b7b7d3e8be44568f5de8e"
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
