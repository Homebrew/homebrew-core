class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "https://downloads.metabase.com/v0.39.3/metabase.jar"
  sha256 "81b26d7d9eb1385962a02c2133a2f82e95adeaf425fd329c7f02f98b1161282e"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.metabase.com/start/oss/jar.html"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/metabase\.jar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "414a07bc885e0cd93f4d870098c04124286d4b0bd05d5e1e792f77bee35a963e"
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
