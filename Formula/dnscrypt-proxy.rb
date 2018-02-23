class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://github.com/jedisct1/dnscrypt-proxy"
  url "https://github.com/jedisct1/dnscrypt-proxy/archive/2.0.4.tar.gz"
  sha256 "34b76e6fc774936cc3b8a785022c7314b7235fd283ceb728cd45458002bde9e2"
  head "https://github.com/jedisct1/dnscrypt-proxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfbb9725ba8fd76750be09dbfd24b1364c826d4ff47ef212e40a62fb8a9898fa" => :high_sierra
    sha256 "7e519025d84c718e18f7081dc804cbb07a29701a5ef1530c4490a55b68b5328f" => :sierra
    sha256 "c847d81c4cc14fa10257a5f98963ca90566cf0447566e90764a75d2c9798242e" => :el_capitan
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
    using a random resolver. If you would like to change these settings,
    you will have to edit the configuration file:
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
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
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
