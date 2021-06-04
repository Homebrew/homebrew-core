class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.8.4.tar.gz"
  sha256 "d85c8c52f4d38ab1915eb60523b4e5241ffa19d20e4f7bbce8b0f4fb59171f2a"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a29dc1888819650025fd19c1faf2c99b15eb4838e7bc50690f684a686121b3f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd22bbdc9ca2dca3885d64db3ec204f1d2a5e3f72a5ebb17da28935d0574aca2"
    sha256 cellar: :any_skip_relocation, catalina:      "55ae437286e90671271c534c04511dc70f345038084639074504d94782308015"
    sha256 cellar: :any_skip_relocation, mojave:        "3f8cb527b416b4221ab2a332d0515566c15179c10ef8dbcc4eb7a0f47aea7025"
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
