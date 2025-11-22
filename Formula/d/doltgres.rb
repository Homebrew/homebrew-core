class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.53.4.tar.gz"
  sha256 "c3fa41db9c7ee03af5d995e6a334b935ef8d25379352db68b452910ebbdd1466"
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
    sha256 cellar: :any,                 arm64_tahoe:   "03f727c247f615aa14c2791696229708f3a57be5c8f0da80f71cecdd8f26008c"
    sha256 cellar: :any,                 arm64_sequoia: "12a6d4d3b2147471f5c14939d9329647555e136bc026b104eca950d56852fb85"
    sha256 cellar: :any,                 arm64_sonoma:  "6473b0bf39a18a758c147a86cc548fe285457b93445379c631976eb576fed1dd"
    sha256 cellar: :any,                 sonoma:        "06b465a975ceca62392a63ec7e7d93ebdb1f8e323f2d998465c8c0559a2da65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c7daa917ee1cbd2ba14909ecc9d2043f897eb6102179be0d67659bb90657542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c37af0bcda70ff706bfbc79523cff4c1bec48327e746bbaac1e86f6ee888ed3"
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
