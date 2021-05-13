class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v2.0.6.tar.gz"
  sha256 "b8f019cfb85f7fdcdd5399dc2418cdc1ac302f99da0d031c2e307ecb62e129cd"
  license "MIT"
  revision 1
  head "https://github.com/influxdata/influxdb.git"

  # The regex below omits a rogue `v9.9.9` tag that breaks version comparison.
  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26064c6e61a5f3f21ae929f426f24bc5074821798ddc10a236d5bbec013aea0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "473f7fe873207d149a17358ccb0ae34a6db380884d569f5eefa4c9434d0df87b"
    sha256 cellar: :any_skip_relocation, catalina:      "b239400cc02c0d4b3bbd227bd813b0fee68a9608c5ff0b895a2b8789a287304e"
    sha256 cellar: :any_skip_relocation, mojave:        "6bea10702c042ecc7dffc3c9daf0370846a28d4974b981a25cf0654247ab0de1"
  end

  depends_on "bazaar" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.7.tar.gz"
    sha256 "9bfe2c06b09fe7f3274f4ff8da1d87c9102640285bb38dad9a8c26dd5b9fe5af"
  end

  # NOTE: The version/URL here is specified in scripts/fetch-ui-assets.sh in influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "ui-assets" do
    url "https://github.com/influxdata/ui/releases/download/OSS-v2.0.5/build.tar.gz"
    sha256 "37ffbc072ba801ec5a0abdd76a3f19a8cd75f59856274e20630929f73cedaf55"
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

    # Build the CLI and server.
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"influx", "./cmd/influx"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "assets", "-o", bin/"influxd", "./cmd/influxd"
  end

  test do
    ENV["INFLUXD_BOLT_PATH"] = "#{testpath}/influxd.bolt"
    ENV["INFLUXD_ENGINE_PATH"] = "#{testpath}/engine"

    influxd_port = free_port
    influx_host = "http://localhost:#{influxd_port}"
    ENV["INFLUX_HOST"] = influx_host

    influxd = fork do
      exec "#{bin}/influxd", "--store=memory",
                             "--bolt-path=#{testpath}/influxd.bolt",
                             "--engine-path=#{testpath}/engine",
                             "--http-bind-address=:#{influxd_port}",
                             "--log-level=error"
    end
    sleep 20

    # Check that the CLI works and can talk to the server.
    assert_match "OK", shell_output("#{bin}/influx ping")

    # Check that the server has properly bundled UI assets and serves them as HTML.
    curl_output = shell_output("curl --silent --head #{influx_host}")
    assert_match "200 OK", curl_output
    assert_match "text/html", curl_output
  ensure
    Process.kill("TERM", influxd)
    Process.wait influxd
  end
end
