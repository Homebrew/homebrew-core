class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  # When bumping to 3.x, update license stanza to `license any_of: ["Apache-2.0", "MIT"]`
  # Ref: https://github.com/influxdata/influxdb/blob/main/Cargo.toml#L124
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v2.7.6",
      revision: "3c58c06206bd8c585f847382d074524564174bc1"
  license "MIT"
  head "https://github.com/influxdata/influxdb.git", branch: "main-2.x"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple major/minor versions and the "latest"
  # release may be for an older version, so we have to check multiple releases
  # to identify the highest version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8593997d6a8072614b10cf5a45603436d64aef72af3d65377573bdc58768753c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92f6700b9089c9faa7d0c50d9f8e858de0eb61a165ae41ddb2c40855c8652c49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2de3d2b5694859c53dddfe3ba7f489a7107cc5ce9ee7f80e6a2da567aeef21f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4768de146cb69ec462da844c65f0745d767ac98b0e550da2c49713db5d331212"
    sha256 cellar: :any_skip_relocation, ventura:        "f1144a0fe030b254f10a511a6c9213a2592e7828aa68d59cd0ea8a454abd3ace"
    sha256 cellar: :any_skip_relocation, monterey:       "a09e387af6897a7a5b58087718882454382195dca8bffd6e9fd7b2c621147c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2b5160be70392770344c3b452a8288591127fe3306d04ca2fcd0616798a6a95"
  end

  depends_on "breezy" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.11.tar.gz"
    sha256 "52b22c151163dfb051fd44e7d103fc4cde6ae8ff852ffc13adeef19d21c36682"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/influxdb/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  # NOTE: The version/URL here is specified in scripts/fetch-ui-assets.sh in influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "ui-assets" do
    url "https://github.com/influxdata/ui/releases/download/OSS-v2.7.1/build.tar.gz"
    sha256 "d24e7d48abedf6916ddd649de4f4544e16df6dcb6dd9162d6b16b1a322c80a6f"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/influxdb/v#{LATEST_VERSION}/scripts/fetch-ui-assets.sh"
      regex(/UI_RELEASE=["']?OSS[._-]v?(\d+(?:\.\d+)+)["']?$/i)
    end
  end

  def install
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
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 10)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin/"influxd", ldflags:),
           "-tags", "assets,sqlite_foreign_keys,sqlite_json", "./cmd/influxd"

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
