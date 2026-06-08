class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.56.4.tar.gz"
  sha256 "b18fe514696ce211a98ee922eb19d85326c6935cff9fef5e4cde60dfa671473a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "e59e4976f3396ec50588766dbe8af3fc44de8a127f5709998393c2e07ab3c949"
    sha256 cellar: :any,                 arm64_sequoia: "0c59cca21f18e1abcda162c969aa293a3105b0de92e86b8f49a59ad2118c776a"
    sha256 cellar: :any,                 arm64_sonoma:  "bbf4c3e61d48d6df06c9b11194d357afd993494303ca482be7b0a63075d37fe6"
    sha256 cellar: :any,                 sonoma:        "2d0b64cd741d5ecd02e91d9e6d4a6f2eb82e94056550be3dac896957baa38a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2754e33f71b3d9efe5e1adaf65e17ca2e16893b174fa42f298b45b17c325a3d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35880ea4400e2ca1bf7873ddc4267b5668646a4326529e87770c039186413d0d"
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
