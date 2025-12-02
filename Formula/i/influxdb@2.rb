class InfluxdbAT2 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v2.7.12",
      revision: "ec9dcde5d6f0e1c4d15ff2332127987a42ca30fc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73407bba53e2cd8c4d15f10a1c0cb4dc3d3f1396f09292c926e75b04d797cd7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29507ee2c4d7d0bbcb83dfb45e168a4c613a57d0aaeb1f378f9d0e44f223a933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac9c07dba2be80e138d1366b96a819de10c0909fc6d80b89475fb784a0ea5751"
    sha256 cellar: :any_skip_relocation, sonoma:        "66c5ae27e567c475874392643347addea7970ac720364ae690ff698c596f2d68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d204bf8b14bb2a8708d9bac0f30f343bc679e5e4ef8ebcf484fc546d2a74f318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5fb80475b08420aa318194dcc9789961fa4722e651b17ed0c48abe3271cb873"
  end

  keg_only :versioned_formula

  depends_on "breezy" => :build
  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.14.tar.gz"
    sha256 "465d2fb3fc6dab9aca60e3ee3ca623ea346f3544d53082505645f81a7c4cd6d3"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/influxdb/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  # NOTE: The version/URL here is specified in scripts/fetch-ui-assets.sh in influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "ui-assets" do
    url "https://github.com/influxdata/ui/releases/download/OSS-v2.7.12/build.tar.gz"
    sha256 "682f8660c6b160a918f4631a791c76da1437c62de47d6a5a4cb0bd6a3a8e6800"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/influxdb/v#{LATEST_VERSION}/scripts/fetch-ui-assets.sh"
      regex(/UI_RELEASE=["']?OSS[._-]v?(\d+(?:\.\d+)+)["']?$/i)
    end
  end

  def install
    # Workaround for `error: hiding a lifetime that's elided elsewhere is confusing` with `rust` 1.89+
    # Issue ref: https://github.com/influxdata/flux/issues/5559
    ENV.append_to_rustflags "--allow dead_code --allow mismatched_lifetime_syntaxes"

    # Workaround to avoid patchelf corruption when cgo is required (for flux)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args(output: buildpath/"bootstrap/pkg-config")
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    # Extract pre-build UI resources to the location expected by go-bindata.
    resource("ui-assets").stage(buildpath/"static/data/build")
    # Embed UI files into the Go source code.
    system "make", "generate-web-assets"

    # Build the server.
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 10)}
      -X main.date=#{time.iso8601}
    ]
    tags = %w[
      assets
      sqlite_foreign_keys
      sqlite_json
    ]

    system "go", "build", *std_go_args(output: bin/"influxd", ldflags:, tags:), "./cmd/influxd"

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

  def caveats
    <<~EOS
      This formula does not contain command-line interface; to install it, run:
        brew install influxdb-cli
    EOS
  end

  service do
    run opt_bin/"influxd"
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

    # Check that the server has properly bundled UI assets and serves them as HTML.
    curl_output = shell_output("curl --silent --head #{influx_host}")
    assert_match "200 OK", curl_output
    assert_match "text/html", curl_output
  ensure
    Process.kill("TERM", influxd)
    Process.wait influxd
  end
end
