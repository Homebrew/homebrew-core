class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "6be207f152003ffa989daa53c2a34f924e46a706ee574c9148092b4a4f7664aa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c25436e0c3620249290d8d697d9ee593592fc215d0ed27e8372587e520cfa74b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a0a3d0684540201ce3d3bf8965a3c86bb8192d283f353dfdb75bad155a75f07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83d4a2ead1ae05cbd2966b549653c9bf8c06b93fe70db7f14164b3de10d745c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac5cbbcff64db390fdc38b488ebdb6248a744276a3cbc0e8e91d7e51b7c1ef78"
    sha256 cellar: :any_skip_relocation, ventura:       "7eabd05c9974e336b0163d4c3d205cea9953dd398786168afdfc324631630bc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75c6d7e214dafc389b0b9225a4056a82e9814d4f7eef991e68c6bd2e4027e7f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29e8c6d2c1f81a9f18c9380fffecb6b88cb0a23045696d2abd1904e53784f399"
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
