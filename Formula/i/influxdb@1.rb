class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "a3590973eb0cde8021375bc8460a8cf0c9c6a34ff7949d10c7405d732cb753d7"
  # 1.x is using MIT license while 1.x and 3.x is using dual license (Apache-2.0/MIT)
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a303342dbf45945584393fe98e87ae2e210dcf65c69f9fc23e358d98e34da8c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8e84939842ae8186819923c22b0e9ba19cea82c45c715ba4da3f8d26f43c6ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a853e07adb0fa25bed5b3d0f214125a548c2f625d34a9eb6e1ac559b9a324ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "105212cf7d4142a28a2741b5774a8440c4689b5aeac319c6243655f0d97e4d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d13ec4589a0ed0656ddccb0b945f69a40db80fa3818f1596aedbd6e86e788a6"
    sha256 cellar: :any_skip_relocation, ventura:       "560fa8fdec78ee706b0852d3560ae307229eb9a17ef68a195f57bfa5bbae9af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "404e18314bed394a1d1f177330f91a064d5db5f939b911b2b0e616e9a04eb4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3256763c89cf2904fbd1981ba27702f26e2f6883ec5d7f595769a8c59ef3d22"
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs
  # to be upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.14.tar.gz"
    sha256 "465d2fb3fc6dab9aca60e3ee3ca623ea346f3544d53082505645f81a7c4cd6d3"
  end

  def install
    # Workaround for `error: hiding a lifetime that's elided elsewhere is confusing` with `rust` 1.89+
    ENV.append_to_rustflags "--allow dead_code --allow mismatched_lifetime_syntaxes"

    # Workaround to avoid patchelf corruption when cgo is required (for flux)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    # Set up the influxdata pkg-config wrapper
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args(output: buildpath/"bootstrap/pkg-config")
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    ldflags = "-s -w -X main.version=#{version}"

    %w[influxd influx influx_tools influx_inspect].each do |f|
      system "go", "build", *std_go_args(output: bin/f, ldflags:), "./cmd/#{f}"
    end

    etc.install "etc/config.sample.toml" => "influxdb.conf"
    inreplace etc/"influxdb.conf" do |s|
      s.gsub! "/var/lib/influxdb/data", "#{var}/influxdb/data"
      s.gsub! "/var/lib/influxdb/meta", "#{var}/influxdb/meta"
      s.gsub! "/var/lib/influxdb/wal", "#{var}/influxdb/wal"
    end

    (var/"influxdb/data").mkpath
    (var/"influxdb/meta").mkpath
    (var/"influxdb/wal").mkpath
  end

  service do
    run [opt_bin/"influxd", "-config", HOMEBREW_PREFIX/"etc/influxdb.conf"]
    keep_alive true
    working_dir var
    log_path var/"log/influxdb.log"
    error_log_path var/"log/influxdb.log"
  end

  test do
    (testpath/"config.toml").write shell_output("#{bin}/influxd config")
    inreplace testpath/"config.toml" do |s|
      s.gsub! %r{/.*/.influxdb/data}, "#{testpath}/influxdb/data"
      s.gsub! %r{/.*/.influxdb/meta}, "#{testpath}/influxdb/meta"
      s.gsub! %r{/.*/.influxdb/wal}, "#{testpath}/influxdb/wal"
    end

    begin
      pid = spawn "#{bin}/influxd -config #{testpath}/config.toml"
      sleep 6
      output = shell_output("curl -Is localhost:8086/ping")
      assert_match "X-Influxdb-Version:", output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end
