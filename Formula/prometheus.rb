class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.17.1.tar.gz"
  sha256 "d0b53411ea0295c608634ca7ef1d43fa0f5559e7ad50705bf4d64d052e33ddaf"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2b0e8dd03e8c10721d8ed50bd2ffda451ab525b23697fbadb647b3126699026" => :catalina
    sha256 "72d841f9285cf94cb39df7631961fdfe22e0893c82cf2b60139c8650b6e7e5fd" => :mojave
    sha256 "c48918658678ca828b473fa6378dbbcdc5183cfd4951bdbb6f9225261e65b505" => :high_sierra
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

  def caveats
    <<~EOS
      When used with `brew services`, prometheus' configuration is stored as command line flags in:
        #{etc}/prometheus.args

      Configuration for prometheus is located in the #{etc}/prometheus.yml file.

    EOS
  end

  plist_options :manual => "prometheus"

  def plist
    <<~EOS
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
