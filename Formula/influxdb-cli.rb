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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc289f1883d9af726cf7c3fd2194bab010724c35e94fcef3d822883c3ae0da3a"
    sha256 cellar: :any_skip_relocation, big_sur:       "79766c5f360e64d189d9bb1779a439937df0f31103238011acf035870bdab414"
    sha256 cellar: :any_skip_relocation, catalina:      "7139d36b911a2d2de59b3aaae2a15be89c16cdb4c5e1f9df348f0b0b663565fa"
    sha256 cellar: :any_skip_relocation, mojave:        "d0205c6302aa63526d202ab224e565790a71d5c52e43082b24bddbb22c7b6ee2"
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
