require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.8.10.tar.gz"
  sha256 "dbfd73757f1e46534782efb834bb953234a8dd23f79d412708e48998e94ae28d"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "50bed55c43911fa4da41bd6b9af3f8c7c82e2142455b8cd6f16ed62f8ade441e"
    sha256 cellar: :any_skip_relocation, big_sur:       "d4662670cbc74890be952519b97bfe50cd5dd156a009ea263825e4e249e12df1"
    sha256 cellar: :any_skip_relocation, catalina:      "c2d81125105ec5ede8254d34ecb0a3736c7ce939c94c4b54d33bb422f6730feb"
    sha256 cellar: :any_skip_relocation, mojave:        "12fc9bc5f8ace1f9d2c3d64befab4d09cd31dec1f3e01308c16051da7815e640"
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
