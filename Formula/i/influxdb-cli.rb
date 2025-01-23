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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d319d1a5eb3d7643f4b6b767e0eacf8f1af03eeab6586c6d062a8350d9f95acb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c3c36b35e1fe4d4f4712f72c5ddd12709846f32088f1bc7637e6b3ed24b2fbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f07a68d82c3075c6bf62922c646998bb362c4ea26166f4ecd31738da4e2af9ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91dc24269127d0a41b7faef7d93e61a6ffec9ecb50d0a0cab69465cd66d9c706"
    sha256 cellar: :any_skip_relocation, sonoma:         "65b07fcaf938f712efb30d280dd18ce8a2652de4b9f89f913ccaad300da18d3f"
    sha256 cellar: :any_skip_relocation, ventura:        "e098362c88be1c91f18927ab98efab0bbb3d73603a3383c1c6735b0c27b4bf95"
    sha256 cellar: :any_skip_relocation, monterey:       "f073f4752f61154e3bed747c8e79fe778d51596d16e179506b52106f65225cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a2f1bdca46755b062abdd18f7c3fefc5af42f14e709034c1f2db67e5ca7e896"
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

    system "go", "build", *std_go_args(output: bin/"influx", ldflags:), "./cmd/influx"

    generate_completions_from_executable(bin/"influx", "completion", shells: [:bash, :zsh])
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
