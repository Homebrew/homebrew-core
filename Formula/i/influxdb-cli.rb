class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.7.3",
      revision: "8b962c7e750559f784dd2028633e5f324d4a8da2"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "862fb7d5bf9382668d2e85adcb91b1202c3d71cf064e5427a4b88b83bfac0323"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fae964b628ac9c22bcc64aaa7c94cf3a06ad49287d0de020cf83f595a6749c11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fae964b628ac9c22bcc64aaa7c94cf3a06ad49287d0de020cf83f595a6749c11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fae964b628ac9c22bcc64aaa7c94cf3a06ad49287d0de020cf83f595a6749c11"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ca4a79f1f567978f7fba1cc81b3e1b2dba8dda01495fe1f3a27af0bf5faa03f"
    sha256 cellar: :any_skip_relocation, ventura:        "b42f314bf4427a447671806c3a2aef9d38d719ca20dd1f4bb119c9a6ea7ce431"
    sha256 cellar: :any_skip_relocation, monterey:       "b42f314bf4427a447671806c3a2aef9d38d719ca20dd1f4bb119c9a6ea7ce431"
    sha256 cellar: :any_skip_relocation, big_sur:        "b42f314bf4427a447671806c3a2aef9d38d719ca20dd1f4bb119c9a6ea7ce431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d401f88c1c460971c1813ac0003490d29440ffa9a056cc50e7a693328c18314"
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
