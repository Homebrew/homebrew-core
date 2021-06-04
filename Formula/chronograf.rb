require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.8.10.tar.gz"
  sha256 "dbfd73757f1e46534782efb834bb953234a8dd23f79d412708e48998e94ae28d"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "67ba86d066284a143eb5e0b725c6205d1c35c685dd8218bd143c8ec10963de4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ec58f7ea07930eb1f2b9d4ae90f08c0c0539f2ef1d5391ce3d31006ee319c4d"
    sha256 cellar: :any_skip_relocation, catalina:      "d8bafeef82c5e75363d5a6b8e08bf4cffdd1e45f15cdbc6ad3aee84576e361d1"
    sha256 cellar: :any_skip_relocation, mojave:        "f996a2303272bc562164186e126d244a519285428b445cb3b25430ea2e9fbc30"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  # Switch to `node` when chronograf updates dependency node-sass>=6.0.0
  depends_on "node@14" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    Language::Node.setup_npm_environment

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
