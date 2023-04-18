class InfluxdbAT1 < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v1.11.0.tar.gz"
  sha256 "51bdde988fca05c1d54de82cd1ec096f790db15d00eda1f74d9375f16c22500b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "147eedd437e4203306b325c1fd39c73b438dc384cb9ed3b286d50500da31bb3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36c0f99e67112313b0cde43ac8f59184557414425b8eb61b99b433dd3f1f8741"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a55487ef139a65a14a07dacd554c857268029fed6816da06c8034c186ea0f4b"
    sha256 cellar: :any_skip_relocation, ventura:        "0f35f24db9ebec2a03e3f5e0fcb50b7b63cbd42da2c26da85c302049c54fceac"
    sha256 cellar: :any_skip_relocation, monterey:       "516c3660519327bc13b7fb92a1aa3587b7afcb60b5b25645f33aef05802a0402"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce57d336ba99c3fd4cf578c9e76b64b897bc7b26da1232d24255bd37bcb85dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b35a4c3668c6f930cb0b6cb1d25e2c57a8cae0afaa366b897da7acb19c56d3"
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
