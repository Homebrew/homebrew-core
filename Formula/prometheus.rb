class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.12.0.tar.gz"
  sha256 "9bd9ae6df02777a9ba3f6f544338865861decabd02054aa64975449bd6009e5a"

  bottle do
    cellar :any_skip_relocation
    sha256 "576c8daa947cbb029bd0a57bd666fea97ebfed0945bc4afd5a007ad7554b92bb" => :mojave
    sha256 "be0fb9eef73865a0f173685132a78e1171ebeaffbcc678e4bf9b03a5d34a74ae" => :high_sierra
    sha256 "9ff3e8c550b0d343dc2714c710e1e8e7495608f6058acfd533cfd8c022474a45" => :sierra
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "build"
    bin.install %w[promtool prometheus]
    libexec.install %w[consoles console_libraries]
  end

  def caveats; <<~EOS
    When used with `brew services`, prometheus' configuration is stored as command line flags in
      #{etc}/prometheus.args

    Example configuration:
      echo "--config.file ~/.config/prometheus.yml" > #{etc}/prometheus.args

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
