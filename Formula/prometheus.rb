class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.9.1.tar.gz"
  sha256 "3b234b15e16284ece013ed23d10c1f102041dc00c4ad39ac3af6265005494844"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c2106779d57b09c3b5f171b5e230c2630f1df6fe9e95b1955a1f0c51613f1d8" => :mojave
    sha256 "5707cc36e6f1e0021bd5776ff0ded4f9abef2a643a340f5edf5a435fb420ee7c" => :high_sierra
    sha256 "8044a962b549676d2dbc33776b152d915193d1ffd42a261a6b4a0571684a0ca5" => :sierra
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
