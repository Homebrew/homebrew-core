class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://github.com/jedisct1/dnscrypt-proxy"
  url "https://github.com/jedisct1/dnscrypt-proxy/archive/2.0.30.tar.gz"
  sha256 "f61daf201d80b730dd36f4c7f1888b8ca5776572f7a779d9a306e8c590e388c0"
  head "https://github.com/jedisct1/dnscrypt-proxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe4eaf27826ee480654a332e2a18d9aacec5fe78498d034b89b2d329d8bff32c" => :catalina
    sha256 "ab1c8e93a1514b0e82685e1df37682bc6f0ff45115c52165098cf5bb2300381e" => :mojave
    sha256 "bd84bf7258acdbea8b108a82236c0c920501a7f83d547723bcba15d94dd8dc94" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    prefix.install_metafiles
    dir = buildpath/"src/github.com/jedisct1/dnscrypt-proxy"
    dir.install buildpath.children

    cd dir/"dnscrypt-proxy" do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o",
             sbin/"dnscrypt-proxy"
      pkgshare.install Dir["example*"]
      etc.install pkgshare/"example-dnscrypt-proxy.toml" => "dnscrypt-proxy.toml"
    end
  end

  def caveats; <<~EOS
    After starting dnscrypt-proxy, you will need to point your
    local DNS server to 127.0.0.1. You can do this by going to
    System Preferences > "Network" and clicking the "Advanced..."
    button for your interface. You will see a "DNS" tab where you
    can click "+" and enter 127.0.0.1 in the "DNS Servers" section.

    By default, dnscrypt-proxy runs on localhost (127.0.0.1), port 53,
    balancing traffic across a set of resolvers. If you would like to
    change these settings, you will have to edit the configuration file:
      #{etc}/dnscrypt-proxy.toml

    To check that dnscrypt-proxy is working correctly, open Terminal and enter the
    following command. Replace en1 with whatever network interface you're using:

      sudo tcpdump -i en1 -vvv 'port 443'

    You should see a line in the result that looks like this:

     resolver.dnscrypt.info
  EOS
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dnscrypt-proxy</string>
          <string>-config</string>
          <string>#{etc}/dnscrypt-proxy.toml</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
  EOS
  end

  test do
    config = "-config #{etc}/dnscrypt-proxy.toml"
    output = shell_output("#{sbin}/dnscrypt-proxy #{config} -list 2>&1")
    assert_match "public-resolvers.md] loaded", output
  end
end
