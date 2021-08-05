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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "87209fda062ca2cc837396f553b3b528b4744510666a76d4ce1350e6485f56b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "50ffaa51c50e29f485f8558e6771fa0f221ce52bb2de74de7145dc85a02e1033"
    sha256 cellar: :any_skip_relocation, catalina:      "be4f578608c750b90fafa55ecdebee4d9b322bab6dc849dffef5b2113dc7aa54"
    sha256 cellar: :any_skip_relocation, mojave:        "9fd6a0fed10afc6225b2029fe6b4fa90af0f86cd04074d9c3a5dea4f49225232"
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
