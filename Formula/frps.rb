class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.34.2",
      revision: "1ea1530b362c135b2267656e392ab36317924ca2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0de4a4cc134b9535db22b4aa786870cf6726d74be9cdb8773beb905d6f5041c7" => :catalina
    sha256 "34ac69200c86d9bfa36208ac31a28d3bbacffabd582714e2bf5217073bf67fc7" => :mojave
    sha256 "2cef0bdfbf14951aa6600fd5280b4476c8d88abae2e17dcc2342f4defa7615d2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.ini" => "frp/frps.ini"
    etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
  end

  plist_options manual: "frps -c #{HOMEBREW_PREFIX}/etc/frp/frps.ini"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/frps</string>
            <string>-c</string>
            <string>#{etc}/frp/frps.ini</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/frps.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/frps.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps tcp listen on", output
  end
end
