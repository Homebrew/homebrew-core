class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "57371158652c7c4b1d764d382eff03f4eebc4c295a4c9e4b8e06c1237b81ebef"
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
    sha256 cellar: :any,                 arm64_tahoe:   "e0c1a6be8128ebba4eec7cffcf86eb10eb590fa670145b0545fd5d07f8b81c62"
    sha256 cellar: :any,                 arm64_sequoia: "f1e8c8a931008b68e58b8f83637e71fff71f383a8ff852ae2df6eb5c0b846888"
    sha256 cellar: :any,                 arm64_sonoma:  "682104756332a81d3776cf1258a761f9adb7be2a76453a5d7978c0cc4d1294c7"
    sha256 cellar: :any,                 sonoma:        "14f8ef8fa0bab499079b8fee2349f334b70d96c8a1c2009b9f255aa8fa9a9834"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f735aafbbd4ce12a593f18f783be8e8dd3a2e31e7dfb18e7210356d49f26e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d48e46957a98e1e7ea100652a1ca750103f4a18d3e923e989da81945efd96948"
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
