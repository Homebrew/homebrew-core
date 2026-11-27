class InfluxdbAT2 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v2.10.1",
      revision: "db5102ec64d5dd3dfa87208edb054eb0721c36c9"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "7a4da55ee811f0d22b9f26a9742830a6cd66e1e4977b25b3276aa1c489b25ba7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b620cf9bfb13f290f8ce8e7e216cd329d13d61459eea4761f0073cba6814ae9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3969660a56361c9604b855cdf99e52451cf60a0b11f7f01a62dcd7a45f14f81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "019f7d311265e1a68a195ff702ff5c76f9d2d6eaf0cf93330dfba1599c1c1d0a"
    sha256 cellar: :any,                 arm64_linux:       "d696ffbd6e1ec894c9d7130272d137b58ce58ab4c628ec78abd6e9127af747ec"
    sha256 cellar: :any,                 x86_64_linux:      "5fe0c0f2f81c81acf9676288db3389b15677070ca667b4cb797acb7c0d7590bb"
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
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "11776c4f44b4d338619723cba1a6ef716573e80a358b0943ff2e2a86129ca8d5"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/influxdb/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  # NOTE: The version/URL here is specified in scripts/fetch-ui-assets.sh in influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "ui-assets" do
    url "https://github.com/influxdata/ui/releases/download/OSS-v2.10.0/build.tar.gz"
    sha256 "5f713c66800ff818a15ab450b0004ae0c74e170c638d9001916e8324d57d17a9"

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
    if OS.linux? && Hardware::CPU.arm64?
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
