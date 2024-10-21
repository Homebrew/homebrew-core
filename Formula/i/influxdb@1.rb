class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "a4891ad93c8f1519b9997204ec0ea27506b02723f040fb7b048255117fc27552"
  # 1.x is using MIT license while 1.x and 3.x is using dual license (Apache-2.0/MIT)
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42a6362663fc372a107ada7e51c1d7f10b942d4ac770fbfe87e7e95353f214cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d80433a66810b1af657496a5ac591dccbce954dc7f9c0287d3f346d5072666c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "873182060842a9ae9aed161b53e405e158e7f8da9daa59ff162733266021c8e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c888c45f96e9abcbb11ac20a27ea90f3e1a61e257a329b8ee7700eaf0daefeae"
    sha256 cellar: :any_skip_relocation, ventura:       "8c95f3548a293df66a165564556971382c39df82a93ea31167a047f6d068251b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28add7e9fd8ec22a7bfa233064c7b62ee516cee76ed323ece53829a01748c7d9"
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

  # update flux dep, upstream bug report, https://github.com/influxdata/influxdb/issues/25440
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/984eb256ccb68fe9ee3b3e0f88f7991b0dd55ccb/influxdb@1/1.11.7.patch"
    sha256 "4c6ac695f2302ca320db58f3906f346fa48fbd3706964a8be39c5a3da6080256"
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
