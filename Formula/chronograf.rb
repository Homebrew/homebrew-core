require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.8.8.tar.gz"
  sha256 "82b4bce9c3115eae54ca67770cb31facbd842fdd9f6ca9eb7e2b1a636dd6fae5"
  license "AGPL-3.0"
  head "https://github.com/influxdata/chronograf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78e04ee12c6cafb1b8be0c72580a36c41a79cd26cd94fde4acf91b8c9cf86a83" => :catalina
    sha256 "d6c31b05a25784ced4df964568d314315ac14942caca665a756d2c5e36d44d99" => :mojave
    sha256 "43e036a0c84359212625d8cf7eb7573fe1935bc95a3e99820e30922299252b9d" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    Language::Node.setup_npm_environment

    cd "ui" do # fix compatibility with the latest node
      system "yarn", "upgrade", "parcel@1.11.0"
    end
    system "make", "dep"
    system "make", ".jssrc"
    system "make", "chronograf"
    bin.install "chronograf"
  end

  plist_options manual: "chronograf"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/chronograf</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/chronograf.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/chronograf.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/chronograf --port=#{port}"
    end
    sleep 10
    output = shell_output("curl -s 0.0.0.0:#{port}/chronograf/v1/")
    sleep 1
    assert_match %r{/chronograf/v1/layouts}, output
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
