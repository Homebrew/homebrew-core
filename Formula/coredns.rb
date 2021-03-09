class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.8.3.tar.gz"
  sha256 "9fa12d1f0cc7678cd9973b4a1a27718a4d1e12d78f4a46681cea39f569c2a166"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4962a8aaec7131e62ea3fe80f585fe76d4a430797c3b4dea125fa2ba1fc2e5cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "7d5e1a192386778bbd53c6d2b670cff89e91013e436dd39483a2e25a94a5bf52"
    sha256 cellar: :any_skip_relocation, catalina:      "ed0d07726d5b11a977a0237ef432dea0bfe16f4bdd63a015a9df9710164e71e5"
    sha256 cellar: :any_skip_relocation, mojave:        "7dd4e1388f51b8b8562741df51e16fb6967bfead7954f33ecc30c4327fd91caa"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "coredns"
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/coredns</string>
            <string>-conf</string>
            <string>#{etc}/coredns/Corefile</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/coredns.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/coredns.log</string>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
