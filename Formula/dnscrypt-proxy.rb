class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://github.com/DNSCrypt/dnscrypt-proxy"
  url "https://github.com/jedisct1/dnscrypt-proxy/archive/2.0.41.tar.gz"
  sha256 "ce07f5446982c4c0c60f3fae43268ed923335cea2198db862dfc7d6b8ca3baad"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0b8a7d94df71e4231c9b34050c36636a7b7692d425d03d4667b6d8747eb001d" => :catalina
    sha256 "3d1ccfeddfefe4d7d0aec4983588c2bf2cdf7dfc5c03586636c917e9c8bd0c6f" => :mojave
    sha256 "67ed530a10380bb3113cb57a1c342e0c7eed48c37a9b338e5d086967364e6cd4" => :high_sierra
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

  def caveats
    <<~EOS
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
    assert_match version.to_s, shell_output("#{sbin}/dnscrypt-proxy --version")

    config = "-config #{etc}/dnscrypt-proxy.toml"
    output = shell_output("#{sbin}/dnscrypt-proxy #{config} -list 2>&1")
    assert_match "Source [public-resolvers] loaded", output
  end
end
