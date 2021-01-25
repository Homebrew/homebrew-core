class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.8.1.tar.gz"
  sha256 "fc4902d746eeef5b954a9d3d546cd841766d24a6d4aa7ecf7e2ff832cf818876"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "098ef6db12d262111d1acf135408b3b9a5456ce09b4cd0e78e9c7a1d55a0f892" => :big_sur
    sha256 "2b255a4515bc26a91ee5335ba0daba1b811fe29d3460af89445fac1306c641d7" => :arm64_big_sur
    sha256 "1d1ad1e07e5ee741e6845850983556c325151f9db80944517889752119139f4c" => :catalina
    sha256 "8303822b262d65660fb295870d52d270cfbc9c742b3d8cf8f2ea6481c08a30be" => :mojave
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
