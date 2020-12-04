require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.8.9.tar.gz"
  sha256 "804a09b39bdc14ec468b760af92daf32d1430f2ee50d30520a0ecdf2b62edcaa"
  license "AGPL-3.0"
  head "https://github.com/influxdata/chronograf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1a3a52b2b4d0baf28bb9d9a750ad0e3d0aa38cc0a0206cedb448cc7904b7a9c" => :big_sur
    sha256 "d7f3238fa6d3c884c0fe303cbdd8c4d54c9190c413e2c1bfbd7905811f817930" => :catalina
    sha256 "7d49422c89b520a89fe104048151e81bcefa6da1099980ab069951996eae190a" => :mojave
    sha256 "1fe46b505ec117d07e590c8ffaa48013e910b5a3a8d34522d3029f2b05c782ae" => :high_sierra
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
