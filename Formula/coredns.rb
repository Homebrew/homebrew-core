class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.8.6.tar.gz"
  sha256 "cbe3764afe2148b8047ea7e5cbba5108c298dee3a9a0391028e2980e35beaa2b"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7cd646294eca408805c11310f3791b4ef63b67cd669b5d349dbc3d8b58cc4304"
    sha256 cellar: :any_skip_relocation, big_sur:       "57785bdeb8d23c2d57d0a00b67256d71b809f521cbf7be1afe60718456aa98b9"
    sha256 cellar: :any_skip_relocation, catalina:      "683484a7f4185a6bb6b3033ab64d219c709b96f2278fba22c277ce2ac9ef2c11"
    sha256 cellar: :any_skip_relocation, mojave:        "310dde73b21bfd8e85f1aac99e450c42cb23e7a0c89f7b5d6c0aadd2d7156cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8670aa20afb469e2a4e72fee4ab9175ae9d76a08015e3ca3539b069a3030b30"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

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
