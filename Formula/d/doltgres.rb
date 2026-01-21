class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.54.10.tar.gz"
  sha256 "283a9aa4763a24662827925dc140a0a36117696e09b11a5d28756730308e4a6a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "4899d0aadb4d0f9d6686c50da000814d98578b4e733b68be59a0addc402675df"
    sha256 cellar: :any,                 arm64_sequoia: "c52b6d8319aee878a3d7af3b7ab966fc82bce63b44e310855a80ad3721f2fd57"
    sha256 cellar: :any,                 arm64_sonoma:  "a689d0c4a625ecb940ea450e2e50aff6231d4eedc3ece684ac4f1e7896b1c1d2"
    sha256 cellar: :any,                 sonoma:        "e274a3319b1869813e72f454c07933cbf9bc68e80e0348789340cc5d98637fef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05dc2d04843e05aba9b0da2fb2f00724dda02d801a3e490d19727697ff554d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26cfebc7b547d27941a28ea8a8719d2ece8d1a96a414938eb1de79fceccb9dc7"
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
