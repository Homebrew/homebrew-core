class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.6.1",
      revision: "61c5b4d5338321e46544f8810e44916b1bd071b6"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b6f2900ae325a5d3238daddb954d30788b8960236b3765a398e0dc56f03bea3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72dfaae3242f8397542b3f7c37250545e61880bcf82d7a31e40908335ad43e2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ba45fae202013c6fedeb96aa42644ed0350ba702b5c60c6ecf01bc4c6038de9"
    sha256 cellar: :any_skip_relocation, ventura:        "a82fb72eafcc5436863897a4903c9700d8c617dff59f2aded291d946f398bf01"
    sha256 cellar: :any_skip_relocation, monterey:       "5ec721cf534147b5c3d6853e0839651fe020d8c80aebc32b8d7d6b2cb0f8d3a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "473bbdc71801ee522d36be7b75ec7d116fecb31e2d2cf622e356c336d2d809d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "343770ba5ef18d28383b76fe9f0d80e094dfe5f4eae0cf773050118c9b5a95e4"
  end

  depends_on "go" => :build
  depends_on "influxdb" => :test

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 10)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin/"influx", ldflags: ldflags), "./cmd/influx"

    generate_completions_from_executable(bin/"influx", "completion", base_name: "influx", shells: [:bash, :zsh])
  end

  test do
    # Boot a test server.
    influxd_port = free_port
    influxd = fork do
      exec "influxd", "--bolt-path=#{testpath}/influxd.bolt",
                      "--engine-path=#{testpath}/engine",
                      "--http-bind-address=:#{influxd_port}",
                      "--log-level=error"
    end
    sleep 30

    # Configure the CLI for the test env.
    influx_host = "http://localhost:#{influxd_port}"
    cli_configs_path = "#{testpath}/influx-configs"
    ENV["INFLUX_HOST"] = influx_host
    ENV["INFLUX_CONFIGS_PATH"] = cli_configs_path

    # Check that the CLI can connect to the server.
    assert_match "OK", shell_output("#{bin}/influx ping")

    # Perform initial DB setup.
    system "#{bin}/influx", "setup", "-u", "usr", "-p", "fakepassword", "-b", "bkt", "-o", "org", "-f"

    # Assert that initial resources show in CLI output.
    assert_match "usr", shell_output("#{bin}/influx user list")
    assert_match "bkt", shell_output("#{bin}/influx bucket list")
    assert_match "org", shell_output("#{bin}/influx org list")
  ensure
    Process.kill("TERM", influxd)
    Process.wait influxd
  end
end
