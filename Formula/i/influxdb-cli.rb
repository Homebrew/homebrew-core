class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.7.5",
      revision: "a79a2a1b825867421d320428538f76a4c90aa34c"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46886e6a377ff4bb11ef2e90ce50730c08901f0abb801e5a402183b0c79ab700"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a1f6db5dfcf2d285e33ec200fcf44c48ee87ca51c3cafda2eefd94588b4eef4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a1f6db5dfcf2d285e33ec200fcf44c48ee87ca51c3cafda2eefd94588b4eef4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a1f6db5dfcf2d285e33ec200fcf44c48ee87ca51c3cafda2eefd94588b4eef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "af4529363356a536ee7099771130580d6bde0dd377398b2a3997d82c55b2b330"
    sha256 cellar: :any_skip_relocation, ventura:       "af4529363356a536ee7099771130580d6bde0dd377398b2a3997d82c55b2b330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38fe1c516a17a8d874e17e510ec59594d3acb60636c431c0b9b7411bc1e68ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db4024e85728111abfae88af4088b98d75c2f15bb873b12e9f546b4ce2110dde"
  end

  depends_on "go" => :build
  depends_on "influxdb@2" => :test

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 10)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin/"influx", ldflags:), "./cmd/influx"

    generate_completions_from_executable(bin/"influx", "completion", shells: [:bash, :zsh])
  end

  test do
    # Boot a test server.
    influxd_port = free_port
    influxd_args = %W[
      --bolt-path=#{testpath}/influxd.bolt
      --engine-path=#{testpath}/engine
      --http-bind-address=:#{influxd_port}
      --log-level=error
    ]
    influxd = spawn Formula["influxdb@2"].opt_bin/"influxd", *influxd_args
    sleep 30

    # Configure the CLI for the test env.
    influx_host = "http://localhost:#{influxd_port}"
    cli_configs_path = "#{testpath}/influx-configs"
    ENV["INFLUX_HOST"] = influx_host
    ENV["INFLUX_CONFIGS_PATH"] = cli_configs_path

    # Check that the CLI can connect to the server.
    assert_match "OK", shell_output("#{bin}/influx ping")

    # Perform initial DB setup.
    system bin/"influx", "setup", "-u", "usr", "-p", "fakepassword", "-b", "bkt", "-o", "org", "-f"

    # Assert that initial resources show in CLI output.
    assert_match "usr", shell_output("#{bin}/influx user list")
    assert_match "bkt", shell_output("#{bin}/influx bucket list")
    assert_match "org", shell_output("#{bin}/influx org list")
  ensure
    Process.kill("TERM", influxd)
    Process.wait influxd
  end
end
