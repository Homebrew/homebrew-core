class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.37.0",
      revision: "cfd1a3128aa81e0a6c1103c1f2cbed345aa858de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "236a4b01aaaeb4e9fb088a23153b49cc14c25b5fc29e95f9354875e5c95d933a"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f0aa7c413cce11341f70b0bb9c701ad22403251b12d1a1c329fc03141601d00"
    sha256 cellar: :any_skip_relocation, catalina:      "0f0aa7c413cce11341f70b0bb9c701ad22403251b12d1a1c329fc03141601d00"
    sha256 cellar: :any_skip_relocation, mojave:        "0f0aa7c413cce11341f70b0bb9c701ad22403251b12d1a1c329fc03141601d00"
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
