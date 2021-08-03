class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v1.8.5.tar.gz"
  sha256 "03e43e494777b117366831b45c14663c569479ac84ddef9fc83a50f6708b49f2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "995eb91ced1cf89dd67db698aaf19c8a383409ea09dee11bc1b65808fb3fc93c"
    sha256 cellar: :any_skip_relocation, big_sur:       "faf03387f38258cd1e2559d241105cf812c5744212f615a45364330d33d2e60f"
    sha256 cellar: :any_skip_relocation, catalina:      "a0b6a21ccfa92edc94bf9fe3ecd52f1330537a40d90dd8006546559cc69447d5"
    sha256 cellar: :any_skip_relocation, mojave:        "8d77ad366087718862cf653c162d1e1c5a035e1baf6c70c3fc7c9b88d367387c"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"

    %w[influxd influx influx_tsm influx_stress influx_inspect].each do |f|
      system "go", "build", "-ldflags", ldflags, *std_go_args, "-o", bin/f, "./cmd/#{f}"
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
      pid = fork do
        exec "#{bin}/influxd -config #{testpath}/config.toml"
      end
      sleep 6
      output = shell_output("curl -Is localhost:8086/ping")
      assert_match "X-Influxdb-Version:", output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end
