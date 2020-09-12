class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.36.5.1/metabase.jar"
  sha256 "1296cecd6c98609ef9ed4a9f836a607e531b0b503a59c2b82490c4e6e07b01f1"
  license "AGPL-3.0-only"

  livecheck do
    url "https://github.com/metabase/metabase/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

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

    bin.write_jar_script libexec/"metabase.jar", "metabase"
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
