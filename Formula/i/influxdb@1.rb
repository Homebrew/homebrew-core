class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "386ffaae9b050c52e720153f6c52b4a832d97edbfd589ffe498a269b6fe09fbf"
  # 1.x is using MIT license while 1.x and 3.x is using dual license (Apache-2.0/MIT)
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a54efa19a98e686d906825fc5aa9fed8c740c38a76c9bd3e2b7946d2eeda0dfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccd1fbfca74c70cf224bf1c12823f480cd7b6538c1e5289adba8574afd446b05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19953f46f583a2f2295bb3fa8f551cbf324c8b1f8b699ac01a538f44803dad3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1da2fcc61dc5a233920aa387e0009e2c50488b20fc5901ad2a78353a9f02d48c"
    sha256 cellar: :any_skip_relocation, ventura:       "b02e6c03e1e7ca6a1e71985ae1adeb0ff867e47bf22d84ef5231ab0ce037459d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79494e554b7bd0f9f1191d40a86a23bd5ef01e58ab2f8bc99ad088603023ce2d"
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
