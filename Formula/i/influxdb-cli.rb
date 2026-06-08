class InfluxdbCli < Formula
  desc "CLI for managing resources in InfluxDB v2"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influx-cli.git",
      tag:      "v2.8.0",
      revision: "8cdf40161d7662e942582086853fca948fc1a842"
  license "MIT"
  head "https://github.com/influxdata/influx-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ec938018c24cbb1d9359771834d0d4c2afbacd19e4ee9790f43618a07dc8856"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ec938018c24cbb1d9359771834d0d4c2afbacd19e4ee9790f43618a07dc8856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ec938018c24cbb1d9359771834d0d4c2afbacd19e4ee9790f43618a07dc8856"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e402236f6a5ce614c316fe316efd84fe554cbed4254f4a9f79a1b28f6ff6a9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c36a18dccd15dff18dc96676b0ec93aabb3b551c4430f14706984991bdbef816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53092ca5914faa8045e3bc9b1dfa2f79eb8c81eb62555cd809f1dd36f2755095"
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
