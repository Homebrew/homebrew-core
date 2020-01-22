class Alertmanager < Formula
  desc "Prometheus Alertmanager"
  homepage "https://prometheus.io/docs/alerting/alertmanager/"
  url "https://github.com/prometheus/alertmanager/archive/v0.20.0.tar.gz"
  sha256 "4789ef95b09ba86a66a2923c3535d1bfe30a566390770784c52052c7c83ee1bc"

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/prometheus/alertmanager"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/alertmanager"

    system "make", "build"
    bin.install %w[alertmanager amtool]
  end

  def post_install
    (var/"alertmanager").mkdir

    (etc/"alertmanager.args").write <<~EOS
      --config.file=#{etc}/alertmanager.yml \
      --web.listen-address=127.0.0.1:9093 \
      --storage.path=#{var}/alertmanager
    EOS

    (etc/"alertmanager.yml").write <<~EOS
      route:
        receiver: dummy

      receivers:
        - name: dummy
    EOS
  end

  def caveats; <<~EOS
    When used with `brew services`, alertmanager' configuration is stored as command line flags in
      #{etc}/alertmanager.args file.

    Configuration for prometheus is located in the #{etc}/prometheus.yml file.

  EOS
  end

  plist_options :manual => "alertmanager"

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
          <string>#{opt_bin}/alertmanager $(&lt; #{etc}/alertmanager.args)</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{var}/alertmanager</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/alertmanager.err.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/alertmanager.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    (testpath/"rules.example").write <<~EOS
      route:
        receiver: dummy

      receivers:
        - name: dummy
    EOS
    system "#{bin}/amtool", "check-config", testpath/"rules.example"
  end
end
