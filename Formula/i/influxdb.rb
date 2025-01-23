class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  # When bumping to 3.x, update license stanza to `license any_of: ["Apache-2.0", "MIT"]`
  # Ref: https://github.com/influxdata/influxdb/blob/main/Cargo.toml#L124
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v2.7.11",
      revision: "fbf5d4ab5e65d3a3661aa52e1d05259d19a6a81b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "577ba9284522799541c29345f9c05007fa0a4d49c506e9d6e3ef8410cf070bba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cb31a2b14b041a044bb1bd8ca75a3a1799d6ab4c9981d95eafe2675cf1786fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ff048a6a4b8784a6f07c16c40a406fa90f7acc77b9f6db1d2b59403fac0d211"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cbda744c82743c7e1b0193708c813b22602b65ce9c3c5117f595ea44933103e"
    sha256 cellar: :any_skip_relocation, ventura:       "5b206daf7596804851d172d0f70d0713b2477a1cc7fb58d5b0c18a3deba9a6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dce1ad38f5b09ae95904350471e1d3dd7dd9eb1558e07c52e9dda1db2dd8ab2a"
  end

  depends_on "breezy" => :build
  depends_on "go" => :build
  depends_on "pkgconf" => :build
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

  # rust 1.83 build patch, upstream pr ref, https://github.com/influxdata/flux/pull/5516
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a188defd190459f5d1faa8c8f9e253e8f83ca161/influxdb/2.7.11-rust-1.83.patch"
    sha256 "15fa09ae18389b21b8d93792934abcf85855a666ddd8faeaeca6890452fd5bd4"
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
      -s -w
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
