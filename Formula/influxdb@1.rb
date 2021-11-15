class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v1.8.9.tar.gz"
  sha256 "3730cdee96e5fed8adc39ba91e76772c407c3d60b9c7eead9b9940c5aeb76c83"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e87ffa4110bab2fe14d287358c21728cc25d13134277f34b4bca6ff7f3b08d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db82d8205433e39160b463693ed6f6e291674735d5aa05f944035213b090b35a"
    sha256 cellar: :any_skip_relocation, monterey:       "dd9013f106fdbd8fcce4f1995c73638c958e6d0e8b7c3545c8018e1e73a20e9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dc4895864df3fe8bc027ebae8fab14152600fd12566ded62d1647b2a47a2608"
    sha256 cellar: :any_skip_relocation, catalina:       "133759ca7ea95bcb390a87b3d784e6d75f2f650ee4a7be77b488cd8e481cea24"
    sha256 cellar: :any_skip_relocation, mojave:         "d040c44fa708edea7af6ec05f5a44ec222025569245fa2a71b1b0c697a07b498"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"

    %w[influxd influx influx_stress influx_inspect].each do |f|
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
