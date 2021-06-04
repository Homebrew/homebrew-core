class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.27.1.tar.gz"
  sha256 "90df7ed4b3a68e7cd0fe9fc8e94732aedecc2ed5f2828eb515507db64f024c2f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "190d3da187c5a6ba2fbdc5eb80d958abbab03ebedb6694df5ce371acaf69232f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b7d705f33fde8713e986e050a470b01e5bd1d9eb266813e1b48985df9a5caa8d"
    sha256 cellar: :any_skip_relocation, catalina:      "4010a42f209a16e32bdce3331679839eafbc2e527f43ffe9429fc41d2ab9e88e"
    sha256 cellar: :any_skip_relocation, mojave:        "acd45c1800b8c73e28e384bd2c36f749976ca7455270a415374b42ac240b4277"
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

    (bin/"prometheus_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/prometheus $(<#{etc}/prometheus.args)
    EOS

    (buildpath/"prometheus.args").write <<~EOS
      --config.file #{etc}/prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}/prometheus
    EOS

    (buildpath/"prometheus.yml").write <<~EOS
      global:
        scrape_interval: 15s

      scrape_configs:
        - job_name: "prometheus"
          static_configs:
          - targets: ["localhost:9090"]
    EOS
    etc.install "prometheus.args", "prometheus.yml"
  end

  def caveats
    <<~EOS
      When run from `brew services`, `prometheus` is run from
      `prometheus_brew_services` and uses the flags in:
         #{etc}/prometheus.args
    EOS
  end

  plist_options manual: "prometheus --config.file=#{HOMEBREW_PREFIX}/etc/prometheus.yml"

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
            <string>#{opt_bin}/prometheus_brew_services</string>
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
