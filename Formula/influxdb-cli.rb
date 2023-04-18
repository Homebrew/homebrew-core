class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.7.1",
      revision: "401f3a40326616d5b5f32e814db0248982f557f5"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d29de3f489e25ee85d75140fae52e063fe333cf328de0dea7a3ade1fade665d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d29de3f489e25ee85d75140fae52e063fe333cf328de0dea7a3ade1fade665d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d29de3f489e25ee85d75140fae52e063fe333cf328de0dea7a3ade1fade665d"
    sha256 cellar: :any_skip_relocation, ventura:        "7b8d0820d74193112fb9c8170e5692984e45ae8c90c4dc673be4bde0d654d786"
    sha256 cellar: :any_skip_relocation, monterey:       "7b8d0820d74193112fb9c8170e5692984e45ae8c90c4dc673be4bde0d654d786"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b8d0820d74193112fb9c8170e5692984e45ae8c90c4dc673be4bde0d654d786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b43990ed8814f0441242f9be678da14780c044650febbef202d6b24faabef65a"
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
