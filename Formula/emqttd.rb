class Emqttd < Formula
  desc "Erlang MQTT Broker"
  homepage "http://emqtt.io"
  url "http://emqtt.io/emqttd-macosx-2.1.zip"
  sha256 "7202e0380dad709df47f6aa39a19dda48fa409d85c8155d46b51364981bade5f"

  bottle :unneeded

  depends_on "openssl"
  
  def install
      prefix.install Dir["*"]
      bin.install Dir[libexec/"/bin/emqttd"]
      rm %W[#{bin}/emqttd.cmd #{bin}/emqttd_ctl.cmd]
  end

  plist_options :manual => "emqttd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/emqttd</string>
        <key>RunAtLoad</key>
        <true/>
        <key>EnvironmentVariables</key>
        <dict>
          <!-- need erl in the path -->
          <key>PATH</key>
          <string>#{HOMEBREW_PREFIX}/sbin:/usr/bin:/bin:#{HOMEBREW_PREFIX}/bin</string>
          <key>CONF_ENV_FILE</key>
          <string>#{etc}/emq.conf<string>
        </dict>
      </dict>
    </plist>
    EOS
  end

  test do
    system emqttd, "start"
    system emqttd_ctl, "status"
    system emqttd, "stop"
  end
end
