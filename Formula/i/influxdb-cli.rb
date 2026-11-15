class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "5a16c3866640518339a31fe03a25c341f6f9ae5c2fbd149c5bc47e95e6e9e8b9"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2025db0610e7d193082a57d859a96fb901f30125d25210882fc8a76e7069235"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2025db0610e7d193082a57d859a96fb901f30125d25210882fc8a76e7069235"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2025db0610e7d193082a57d859a96fb901f30125d25210882fc8a76e7069235"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "83c9b2e10261809b33410f5c232c063ca80afe72cd0244d53857b508037dbe8c"
    sha256 cellar: :any,                 x86_64_linux:      "02ea0b70b62b66bba90d785ba425b960fdf4276c65f9bdb3f78776ce3418fd20"
  end

  depends_on "go" => :build
  depends_on "influxdb@2" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Although project no longer uses GoReleaser, the defines were kept the same
    system "go", "build", *std_go_args(output: bin/"influx", ldflags: :goreleaser), "./cmd/influx"

    generate_completions_from_executable(bin/"influx", "completion", shells: [:bash, :zsh])
  end

  test do
    # Boot a test server.
    influxd_port = free_port
    influxd_args = %W[
      --bolt-path=#{testpath}/influxd.bolt
      --engine-path=#{testpath}/engine
      --http-bind-address=:#{influxd_port}
      --log-level=error
    ]
    influxd = spawn formula_opt_bin("influxdb@2")/"influxd", *influxd_args
    sleep 30

    # Configure the CLI for the test env.
    influx_host = "http://localhost:#{influxd_port}"
    cli_configs_path = "#{testpath}/influx-configs"
    ENV["INFLUX_HOST"] = influx_host
    ENV["INFLUX_CONFIGS_PATH"] = cli_configs_path

    # Check that the CLI can connect to the server.
    assert_match "OK", shell_output("#{bin}/influx ping")

    # Perform initial DB setup.
    system bin/"influx", "setup", "-u", "usr", "-p", "fakepassword", "-b", "bkt", "-o", "org", "-f"

    # Assert that initial resources show in CLI output.
    assert_match "usr", shell_output("#{bin}/influx user list")
    assert_match "bkt", shell_output("#{bin}/influx bucket list")
    assert_match "org", shell_output("#{bin}/influx org list")
  ensure
    Process.kill("TERM", influxd)
    Process.wait influxd
  end
end
