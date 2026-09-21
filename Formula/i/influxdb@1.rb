class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "8a5546252029301889172ccc6b4516be8d3b216d702390d8529d59d3847699db"
  # 1.x is using MIT license while 1.x and 3.x is using dual license (Apache-2.0/MIT)
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c6e2e73d4f7ad6d9e741e8a44f260d31b6ef1b6a1fd43d5f6edfe972b3f77d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a5f5b4a40df9fe0e64ea377000e49bc5b2261ee2bda92c3b1be50e25d1a4a8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d753dba9a7eb0acb6ceae1d6be87a8cb0dd430cb33eaabcb40cc618f3241544c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "31bce74501851b0e6ddf8010a8779a90fe837ab1083dac6e9ba09dcb7b319084"
    sha256 cellar: :any,                 arm64_linux:       "ad350dda4d1bea32f53456346643d74545367b1958c788697104681a858cd7ee"
    sha256 cellar: :any,                 x86_64_linux:      "94f2ae62017b2f72b42bae3347f96d26b29f765ca515db5771eb4e006ff76449"
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs
  # to be upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.3.0.tar.gz"
    sha256 "769deabe12733224eaebbfff3b5a9d69491b0158bdf58bbbbc7089326d33a9c8"
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

    %w[influxd influx influx_tools influx_inspect].each do |f|
      system "go", "build", *std_go_args(output: bin/f, ldflags: "-X main.version=#{version}"), "./cmd/#{f}"
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
