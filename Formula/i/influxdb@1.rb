class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "72c2d8e49b1e6dc312a4455a8cc1b5d21e3102be2728f02845e65e178e6446ea"
  # 1.x is using MIT license while 1.x and 3.x is using dual license (Apache-2.0/MIT)
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16b3548c415d304a629c379939a0f7379febf35f3d180af60415a791cf261ae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2c882c9552f107594bfef76088e39f875507a1a281f48496b074d933d7910f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21dc0f1c9ae91464dd244b9536ca2c839d75e8f1afccf1c611ff33d8fdfb3526"
    sha256 cellar: :any_skip_relocation, sonoma:        "14c6a693ba5ba1e90b6bbe6a454b499e5704e40260b565fac98e806f030aa2c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4152ccee52235ce87ab368dfadaae872d048a570f23ad4e6edb50b0f43f34b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a82e92d4339b7e6383dec00fb60e88cddafa23949749639ca82e635d93dd71b2"
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
      s.gsub! %r{/.*/.influxdb/data}, testpath/"influxdb/data"
      s.gsub! %r{/.*/.influxdb/meta}, testpath/"influxdb/meta"
      s.gsub! %r{/.*/.influxdb/wal}, testpath/"influxdb/wal"
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
