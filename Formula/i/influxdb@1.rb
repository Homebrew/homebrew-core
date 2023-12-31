class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "dc6942eb742220a175d43588ecbccb7d3abb00e8aa8f5c515e33f98f99ba8518"
  # 1.x is using MIT license while 1.x and 3.x is using dual license (Apache-2.0/MIT)
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "351b018aaa70bf27f9c67215f3c1320aa49c0eead2be83993895aadc2bba0ad3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "255776ceb20f15adb3f26db42432ab0dacddf6189b7d1d19bb87d20673d03f25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "206b89473ae14f554cadd728583b0b20573ab396dd94536d872669e8a7dab6da"
    sha256 cellar: :any_skip_relocation, sonoma:         "25389cd43491c1d428cbb3e77f64735d41eacb295083ff1f0ff3ac6b6ed06812"
    sha256 cellar: :any_skip_relocation, ventura:        "d1498dcf77bb8520b626bc28888ec16c0b93c522c95924ab2a010d0e52d2219b"
    sha256 cellar: :any_skip_relocation, monterey:       "ad9952add9ba7268e1de10f878a07b53024b0b5f07425c46331c8d0dedc175c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21dc7d9273fd0629a9fc0ac85ae9552b8822949ff0ed4e1a99ad8df08fac194c"
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

  # Build patch to build with Rust 1.72+
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5557bf4d21d86a0aa8495861441a4b5457f18b6b/influxdb%401/1.11.4-rust.patch"
    sha256 "28e382e5a134377d01462661185dcdeaa9864c0a626acfd17964b90bd58d3ad5"
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
