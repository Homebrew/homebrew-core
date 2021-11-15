class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.2.1",
      revision: "31ac78361b8aaae2aba966eb69054ea107028044"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caf7f1fbc75839240bc0311dc94c5e34caddcc92de8784babde1bec1a6b40da6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a00aeb8af79afeffa06dec4b24287b364cf1900e33bdd0217e26fb5e9bb4aff"
    sha256 cellar: :any_skip_relocation, monterey:       "abcce77b01b318d3ce600f84ad6fc2693c994f2682996a7911bfe78094071245"
    sha256 cellar: :any_skip_relocation, big_sur:        "246ed09000d1fae897da9bf1c2d17de559c03e8ce4c6bbf83edef81fe0679365"
    sha256 cellar: :any_skip_relocation, catalina:       "cf8474e13d6092e7e7c45df7d868d649c2c60872069704fc9988d71641a9bbb8"
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
