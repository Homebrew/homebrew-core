class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v1.10.0.tar.gz"
  sha256 "2efe515ba55e4fee18a994902bb3de242f0d498e3662e6cec1548c7f700d8278"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a227d99a24905a7ce83f2b8726643ad96c98e52ffb28a1ad02f91c1b7f8ef155"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15f2975fbb4840dbf635669ad98a44eedb49a08253e565a692ace55c3ea3a5d2"
    sha256 cellar: :any_skip_relocation, monterey:       "d29e6e0cf8758c3e0e55becad5e4b908a2aa0b9ff2aa4c90f72258f5986c88af"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee0a66646092723683a124f764327dc639f24dcc8d090f71899d78f4047c91fd"
    sha256 cellar: :any_skip_relocation, catalina:       "06ba8b1160b29c9ce3eff969df29478ae2b40241cdadb066e6e3b96e351afd51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3e95b7e154b320eefc0819528a5c2144b6b13df799253438c6876a25a9eacd9"
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs
  # to be upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.11.tar.gz"
    sha256 "52b22c151163dfb051fd44e7d103fc4cde6ae8ff852ffc13adeef19d21c36682"
  end

  def install
    # Set up the influxdata pkg-config wrapper
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args(output: buildpath/"bootstrap/pkg-config")
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    ldflags = "-s -w -X main.version=#{version}"

    %w[influxd influx influx_tools influx_inspect].each do |f|
      system "go", "build", *std_go_args(output: bin/f, ldflags: ldflags), "./cmd/#{f}"
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
