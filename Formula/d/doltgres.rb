class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.56.7.tar.gz"
  sha256 "f53a77ccb78a104c40eb0a2c352fdfd7028bb2e38058fbf16b77394c5d520073"
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
    sha256 cellar: :any, arm64_tahoe:   "c038fb25f2320442367383b9b28479bdf988e9a621dd73a220fcdfcf109f196b"
    sha256 cellar: :any, arm64_sequoia: "edd8f869857d6b5885547be9a2f794e3c3cd01cc40a8f15a1f0243766e6a9222"
    sha256 cellar: :any, arm64_sonoma:  "0a438443dbca8a23dfaa8921a9efd1c5f47d184829434c3d0f7ee15bcc756f2b"
    sha256 cellar: :any, sonoma:        "7c3cda110b5ee01a63902d4fa9d235d840729dc17ad00e2225bfe4fcb89dedbf"
    sha256 cellar: :any, arm64_linux:   "efe01c50f32082bb50232425bfdca0f787d07be6248f4b2e396539aa112434b1"
    sha256 cellar: :any, x86_64_linux:  "31c23ec5ff845674b9d2d585306883a108c073d369141e82cd146dca6b98be55"
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

    psql = formula_opt_bin("libpq")/"psql"
    connection_string = "postgresql://postgres:password@localhost:#{port}"
    output = shell_output("#{psql} #{connection_string} -c 'SELECT DATABASE()' 2>&1")
    assert_match "database \n----------\n postgres\n(1 row)", output
  end
end
