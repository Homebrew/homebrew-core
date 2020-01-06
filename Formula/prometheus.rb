class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.15.2.tar.gz"
  sha256 "2ba37bced3e90c5e7dd3248918f13f2f3444de748cfe413b0a09f82532c3c553"

  bottle do
    cellar :any_skip_relocation
    sha256 "e488672bc0ac215a82721abe5d2d543e3d3d1610876e32764c920f302da678ae" => :catalina
    sha256 "931ba33b9e6901d5b61c14cf238c59adc183749cabc226a66f442577c7f5f756" => :mojave
    sha256 "fe988a26b80aef4c23dcefcb60cd50899107f82618a8dc7d2e6e6ee7c548750b" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "assets"
    system "make", "build"
    bin.install %w[promtool prometheus]
    libexec.install %w[consoles console_libraries]
  end

  def post_install
    (etc/"prometheus.args").write <<~EOS
      --config.file #{etc}/prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}/prometheus
    EOS

    (etc/"prometheus.yml").write <<~EOS
      global:
        scrape_interval: 15s

      scrape_configs:
        - job_name: "prometheus"
          static_configs:
          - targets: ["localhost:9090"]
    EOS
  end

  def caveats; <<~EOS
    When used with `brew services`, prometheus' configuration is stored as command line flags in:
      #{etc}/prometheus.args

    Configuration for prometheus is located in the #{etc}/prometheus.yml file.

  EOS
  end

  plist_options :manual => "prometheus"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>sh</string>
          <string>-c</string>
          <string>#{opt_bin}/prometheus $(&lt; #{etc}/prometheus.args)</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/prometheus.err.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/prometheus.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    (testpath/"rules.example").write <<~EOS
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    EOS
    system "#{bin}/promtool", "check", "rules", testpath/"rules.example"
  end
end
