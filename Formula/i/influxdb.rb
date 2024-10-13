class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  # When bumping to 3.x, update license stanza to `license any_of: ["Apache-2.0", "MIT"]`
  # Ref: https://github.com/influxdata/influxdb/blob/main/Cargo.toml#L124
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v2.7.10",
      revision: "f302d9730c3c66577bea7bc7199cfae773bf308e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3a42b508ddb1b9afa8127abf8b17de6f061bd82cf1e87fd03a82e4d7a17f5f9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d77bc46ed3327b7b0fdbb00f043c2a1a19d60dea2ba1abc7b456b0132fd27f80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39520065d44f4c22f7e063dc7704779a4f6fc30cfbc8f5c726bc8bc24ca7ca92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1164aadaad10ad149b1751b8c0ccf0b96e671a880ea0ecee3b0bf05537013520"
    sha256 cellar: :any_skip_relocation, sonoma:         "468a05d3b08bebb974a74c0835fbd390b3b779359b7bb7c0af5be1a6fdc444d5"
    sha256 cellar: :any_skip_relocation, ventura:        "0d46147e4aed85b578105188ae7d99b1ce5344340ab1ff1dffac84ce3e001e0b"
    sha256 cellar: :any_skip_relocation, monterey:       "b2b948941a88660812dbade01ef0b6aab00a63f116424c75f68abd831c93d6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc8959bddb5cd650a48835e00bc4b76402cc3c8d56b9efbadff72eb0e415411"
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
    url "https://github.com/influxdata/ui/releases/download/OSS-2.7.8/build.tar.gz"
    sha256 "28ace1df37b7860b011e5c1b8c74830b0ec584d2f86c24e58a7c855c168f58a8"

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
