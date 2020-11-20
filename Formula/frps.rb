class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.34.3",
      revision: "aa0a41ee4e3fd332978d509dcdbb09a7f457c880"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "355e2239d932fa27c51490baf81f7089a7b930af7f0914acb755b3697b9c4272" => :big_sur
    sha256 "91891a9763996630549e03123860518ef5297468837478d8c39936722c7af3c2" => :catalina
    sha256 "19c3257eb15eae43f3ce057ffe0eaefa21c642959b8705e1d522292df9d3f818" => :mojave
    sha256 "924d515b418239e8e51e10fa8145ca667ef4a8730241be1f0f02d79cce527e08" => :high_sierra
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
