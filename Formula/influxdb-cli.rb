class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.5.0",
      revision: "3285a03e9e28ea7dfad232be3b338291f30a61f5"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42e37e47a2276fa487e4dca909948407d22d701f0e13087266c113c65a9cd287"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6541f4fa6fc74114040e84ba6edb996743801e1fd651061c920952079e9fb2f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09199839456e764a78f3f7f0a245f7ca1d4fc6cb080ffed77a2d7224526c5b5a"
    sha256 cellar: :any_skip_relocation, ventura:        "31cbc94b187d48125de9dc56292f690bdbb54157dfc4e6af529d66f78a55b0ab"
    sha256 cellar: :any_skip_relocation, monterey:       "92a3f65a373a27ceb94a0f433c5ce95f66e5b07fbb9eaacf7a6aee28cc62c26d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cb1ae996c846300c5f281e6b48fd926c57dd61b2db1a4581793c3b02a2d9608"
    sha256 cellar: :any_skip_relocation, catalina:       "1e0cd843f99288a61c7f5e921b8da95c3a83b13e98153ade9aadab54bdaf5a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27586f732cba7ae28915e9e1a21ff1dab5b04fce18604e542229c284e5306d4e"
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
