class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.36.1",
      revision: "fdef7448a717a6f0dc2cf2d5eedf5de0c67a7191"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03fdb08a5bacecb3f2243d51c0e709d614d29efa789cb9f8f7a8572f1c01d895"
    sha256 cellar: :any_skip_relocation, big_sur:       "62fd2df721c2f0707968160afe2720ccf7dbc90a354614c24f9e07020e28e23f"
    sha256 cellar: :any_skip_relocation, catalina:      "fcc5d611fb59caaf3f98de2f07caf3dba0db09af3bf7d9189a6d8b5fad4760a5"
    sha256 cellar: :any_skip_relocation, mojave:        "6eac84ff2383fc2af5c46deb708b95876b6ed9f7607c4d90c9a6c13e87932ad5"
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
    assert_match "frps uses command line arguments for config", output
  end
end
