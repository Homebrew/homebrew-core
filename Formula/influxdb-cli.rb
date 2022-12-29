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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72658854161f96409b129b2f47599475c7cd98c9f981dbbbe2ffa818cdf0fc3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15242f7121549d66dc67493e925609d0b8a6a6dcca1e70992493de723691c037"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffdbd796b88a0cbb3ca05540913c3574f4c0ae5d425638657d5bb5712a03ff97"
    sha256 cellar: :any_skip_relocation, ventura:        "a07a7564f816b31a73bafe7b9a9590e22a94fe2db2c013d63edb9619f2d5a87f"
    sha256 cellar: :any_skip_relocation, monterey:       "875dccd9c48f2a7a7bf44b9a75fa35df4b4192ac494932c58eeebc7fd3814231"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4c16d4bc3d61d56b9a943aba0ecf69764c438744eb3db4c057da11b93e79a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3293a4f20e1777b12c0a7e08b0695e92323524f144072db17fd8ea5fde6ae4b8"
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
