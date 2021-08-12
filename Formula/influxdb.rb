class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v2.0.7",
      revision: "2a45f0c0375a7d5615835afa6f81a53444df9cea"
  license "MIT"
  revision 3
  head "https://github.com/influxdata/influxdb.git"

  # The regex below omits a rogue `v9.9.9` tag that breaks version comparison.
  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7a6d19248a8d665dafdb65535db91471c9d1e221a960d6510ebfbd0fc0ed512"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd1d249e726bf558dc5252daca83ec7939989ed10d0bbde603f6c50f313fcfd8"
    sha256 cellar: :any_skip_relocation, catalina:      "74b7abcb4e2eac907741229394e0e4889a3b66af8d379f2797a687e5131d240d"
    sha256 cellar: :any_skip_relocation, mojave:        "728c2867fc14149b2451940d04c53377d06016378b337bfdfde81f0c61727189"
  end

  depends_on "bazaar" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "influxdb-cli"

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.7.tar.gz"
    sha256 "9bfe2c06b09fe7f3274f4ff8da1d87c9102640285bb38dad9a8c26dd5b9fe5af"
  end

  # NOTE: The version/URL here is specified in scripts/fetch-ui-assets.sh in influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "ui-assets" do
    url "https://github.com/influxdata/ui/releases/download/OSS-v2.0.7/build.tar.gz"
    sha256 "5aebccacb2e13d9fffd1cbca567f63791f3c19be2088045bdbcd38100381101a"
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    # Extract pre-build UI resources to the location expected by go-bindata.
    resource("ui-assets").stage(buildpath/"ui/build")

    # Embed UI files into the Go source code.
    system "make", "generate"

    # Build the server.
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 10)}
      -X main.date=#{time.iso8601}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags),
           "-tags", "assets", "-o", bin/"influxd", "./cmd/influxd"

    data = var/"lib/influxdb2"
    data.mkpath

    # Generate default config file.
    config = buildpath/"config.yml"
    config.write Utils.safe_popen_read(bin/"influxd", "print-config",
                                       "--bolt-path=#{data}/influxdb.bolt",
                                       "--engine-path=#{data}/engine")
    (etc/"influxdb2").install config

    # Create directory for DB stdout+stderr logs.
    (var/"log/influxdb2").mkpath
  end

  service do
    run bin/"influxd"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/influxdb2/influxd_output.log"
    error_log_path var/"log/influxdb2/influxd_output.log"
    environment_variables INFLUXD_CONFIG_PATH: etc/"influxdb2/config.yml"
  end

  test do
    influxd_port = free_port
    influx_host = "http://localhost:#{influxd_port}"
    ENV["INFLUX_HOST"] = influx_host

    influxd = fork do
      exec "#{bin}/influxd", "--bolt-path=#{testpath}/influxd.bolt",
                             "--engine-path=#{testpath}/engine",
                             "--http-bind-address=:#{influxd_port}",
                             "--log-level=error"
    end
    sleep 30

    # Check that the CLI works and can talk to the server.
    assert_match "OK", shell_output("influx ping")

    # Check that the server has properly bundled UI assets and serves them as HTML.
    curl_output = shell_output("curl --silent --head #{influx_host}")
    assert_match "200 OK", curl_output
    assert_match "text/html", curl_output
  ensure
    Process.kill("TERM", influxd)
    Process.wait influxd
  end
end
