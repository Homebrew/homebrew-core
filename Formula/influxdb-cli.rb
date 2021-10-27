class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.2.0",
      revision: "c3690d85842b3481b727ab04c50b785c53451538"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cfc4d3d0f285c28c1368391243fa5a0803123b6a13049f195dcb799ef747917b"
    sha256 cellar: :any_skip_relocation, big_sur:       "d232cfb24c6e6c07bbd9814dae119de2db51b9b79963d503332231d2628ef85d"
    sha256 cellar: :any_skip_relocation, catalina:      "99e87a5e302ae73d4695ef8802269ea97c0511c8a3485a2a89598c4630c7f1be"
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
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags),
           "-o", bin/"influx", "./cmd/influx"

    bash_complete = buildpath/"bash-completion"
    bash_complete.write Utils.safe_popen_read(bin/"influx", "completion", "bash")
    bash_completion.install bash_complete => "influx"

    zsh_complete = buildpath/"zsh-completion"
    zsh_complete.write Utils.safe_popen_read(bin/"influx", "completion", "zsh")
    zsh_completion.install zsh_complete => "_influx"
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
