class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.13.0.tar.gz"
  sha256 "0a11ecc28989ad984af551a5426e9989aa1ca628fc2e875bb913af445ab38288"

  bottle do
    cellar :any_skip_relocation
    sha256 "f07eb0b03e98571b6c663bb1328c73ea113582a73e3974234a95fda16ad00c25" => :catalina
    sha256 "5bc02871196ea7590eca757e0bd1201d0979d58d3de37ddece80de0292b274e7" => :mojave
    sha256 "36403c5fd65ee9bea45fa61abff0462323510cf9f242c9f2e1e176ca462766ac" => :high_sierra
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
