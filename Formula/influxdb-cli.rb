class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.1.1",
      revision: "535183b228b79ae4f0f0a7f4289d62e733be8184"
  license "MIT"
  revision 1
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c68717a9178651388486b28256fe84fa9537b1412e199fa73e9137f9600d6810"
    sha256 cellar: :any_skip_relocation, big_sur:       "2dcafad4c721935f50afc5b61e33638af2b0c94cfddb6b03a9bab42530ac3fb5"
    sha256 cellar: :any_skip_relocation, catalina:      "cf3752b72a1fd20dd08061ea34e27d6043ad366cecb55c397ce3326e032422ae"
    sha256 cellar: :any_skip_relocation, mojave:        "e902f0bf5027cce2b066ded945a406c6b49c1a6dbcea95d2e26ba223843812a7"
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
