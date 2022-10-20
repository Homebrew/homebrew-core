class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.4.0",
      revision: "5c7c34f16db858e1287cdfe162e6481a36f79145"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8ae8aef2a23d8629bceff829d677986fe60e75f5614bb533d1f9f561430b705"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9f84acce048d77e4db132fefffd1eade4b7d801b77ae4d6c6d4e732dd856068"
    sha256 cellar: :any_skip_relocation, monterey:       "f0af336eccd554caa46b01e1cd6aad071e573e3ff4fb790dfe5fea36de256e02"
    sha256 cellar: :any_skip_relocation, big_sur:        "01f723975010eb64195dd1c13f3692ab57f804d5b2ef4c373d8469ee8892914d"
    sha256 cellar: :any_skip_relocation, catalina:       "7bb26bec31006ac6c46f56ae2f51700643eb8ed0cf080ee19d5697525bbec5b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e61fb05c5e7020ff10f3eb32a2894ab8d4387a8c2cb50fb3cafc3426de4a2b1f"
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
