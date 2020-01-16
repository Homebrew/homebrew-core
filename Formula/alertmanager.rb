class Alertmanager < Formula
  desc "Prometheus Alertmanager"
  homepage "https://prometheus.io/docs/alerting/alertmanager/"
  url "https://github.com/prometheus/alertmanager/archive/v0.20.0.tar.gz"
  sha256 "4789ef95b09ba86a66a2923c3535d1bfe30a566390770784c52052c7c83ee1bc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3e2f6180a0594933ac5eeb1f5574d9f07a45479b556702a426697ffa507328fd" => :catalina
    sha256 "7a0549df192cd2b4c23a7322ff2d8096eb19774027f028cbeef5363fb5718862" => :mojave
    sha256 "a68c839c3b0d5d63e768ab069f72b7a4d1c32b385d4d448a3de444b5044e95c3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/prometheus/alertmanager"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/alertmanager"

    system "make", "build"
    bin.install %w[alertmanager amtool]
  end

  def post_install
    (var/"alertmanager").mkdir

    (var/"alertmanager/alertmanager.args").write <<~EOS
      --config.file="#{var}/alertmanager/alertmanager.yml"
      --web.listen-address="127.0.0.1:9093"
      --storage.path="#{var}/alertmanager"
    EOS

    (var/"alertmanager/alertmanager.yml").write <<~EOS
      route:
        receiver: dummy

      receivers:
        - name: dummy
    EOS
  end

  def caveats; <<~EOS
    When used with `brew services`, alertmanager' configuration is stored as command line flags in
    #{var}/alertmanager/alertmanager.yml file.

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
          <string>#{opt_bin}/alertmanager</string>
          <string>$(&lt; #{var}/alertmanager/alertmanager.args)</string>
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
