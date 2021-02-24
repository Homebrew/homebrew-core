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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6a09b43421a78f5ad6a3fad7011c641fcb81ef21b8b8709e75b8bad69228001"
    sha256 cellar: :any_skip_relocation, big_sur:       "10830aee9fc7b1c00bad2ea2f9b2fbd9b00eec2b1c012eb57a135912a351b25f"
    sha256 cellar: :any_skip_relocation, catalina:      "ec9e3e89a39915675a361dbd913f0ea2bbd79dec7c95d173e479b4add8a78c2f"
    sha256 cellar: :any_skip_relocation, mojave:        "526046cafeb98efb6616b3e9802e36fc83273e0c89f6199767b8969fe552ec39"
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
