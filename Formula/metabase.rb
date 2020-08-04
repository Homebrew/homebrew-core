class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.36.2/metabase.jar"
  sha256 "d1bff3b99a7cfb0c441a1bdf23768dde673e6c046e914362df714067b6537cd4"
  license "AGPL-3.0"

  head do
    url "https://github.com/metabase/metabase.git"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    (bin/"metabase").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/metabase.jar" "$@"
    EOS
  end

  plist_options startup: true, manual: "metabase"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/metabase</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}/metabase</string>
        <key>StandardOutPath</key>
        <string>#{var}/metabase/server.log</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
