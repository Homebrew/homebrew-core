class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.3.0",
      revision: "88ba3464cd07599375b4f21589f93bf5a9b1e7e1"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dc7ce5c20f22349ea12425312dc8a5aa01c318db782a325adf420dec25fa06c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e16c4939ed96c3675b53a47a2a6c45e08c1292aa6141e8cda4e75cd75019854"
    sha256 cellar: :any_skip_relocation, monterey:       "deaa9c559c9d373e15f6357132b54d13338e7470ae65075b8194a8524702a727"
    sha256 cellar: :any_skip_relocation, big_sur:        "79a231b102b2966b6056d8ca09ce10316d40064e93d04821dc62522552808012"
    sha256 cellar: :any_skip_relocation, catalina:       "691dcd433af69c8ff9e565f1b943a24cab249ea6a78dab74340bf9fff3dc0bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25b15a9954cad1149ec56687450e091586c9cfd7c6afba2d1117b2fd30a0095a"
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

    output = Utils.safe_popen_read(bin/"influx", "completion", "bash")
    (bash_completion/"influx").write output

    output = Utils.safe_popen_read(bin/"influx", "completion", "zsh")
    (zsh_completion/"_influx").write output
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
