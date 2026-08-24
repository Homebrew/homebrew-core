class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "02cc7b4ec3c46a0aacee44dd7313aa96006bdb7c48dc7bb8f5cf02c5fc1cc0ea"
  # 1.x is using MIT license while 1.x and 3.x is using dual license (Apache-2.0/MIT)
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b5f8d0276bc545cab4a9fe3880f2b436e0f8367940221720a1dc131eac6782c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63fa15d135d8cb70856b1ded888fded93f9ebb88e5480cbfad3ed3ed29f41e0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aae6aafbfa5597a67d58f16cfe28aaeb800d3d72cec7bfb5ed0002d59260f0be"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6f71a3f364b528efb42e18fcdd9832e5acd71f206d3727603d5fa4896adcc2a"
    sha256 cellar: :any,                 arm64_linux:   "51fb720dd2cb00b8593558726f320e0477d986733274f6d6932aa2d3bab19e33"
    sha256 cellar: :any,                 x86_64_linux:  "1da69f852879346335b0fe53aab77888de9f1525d65c003af2fcefd4e38d9747"
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
