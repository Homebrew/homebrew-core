class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.40.1/metabase.jar"
  sha256 "972babb2ce60740729ba56323188bdf998e417dc1d9bac5642d7a429e4a793b1"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e0f2dcc1e8060da2891452863220986388d5a37cb080b7829e570f7ebdaf517"
  end

  head do
    url "https://github.com/metabase/metabase.git"

    depends_on "leiningen" => :build
    depends_on "node" => :build
    depends_on "yarn" => :build
  end

  # metabase uses jdk.nashorn.api.scripting.JSObject
  # which is removed in Java 15
  depends_on "openjdk@11"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    bin.write_jar_script libexec/"metabase.jar", "metabase", java_version: "11"
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
