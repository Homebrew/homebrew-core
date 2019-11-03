class AdguardHome < Formula
  desc "Network-wide ads & trackers blocking DNS server"
  homepage "https://adguard.com/adguard-home.html"
  url "https://github.com/AdguardTeam/AdGuardHome/archive/v0.98.1.tar.gz"
  sha256 "37779d659bb9faa1b2273f70aba4db14a77b4467888953d055547f28e8afa707"
  head "https://github.com/AdguardTeam/AdGuardHome.git", :using => :git

  depends_on "go" => :build
  depends_on "node@8" => :build

  resource "packr" do
    url "https://github.com/gobuffalo/packr/archive/v2.0.1.tar.gz"
    sha256 "cc0488e99faeda4cf56631666175335e1cce021746972ce84b8a3083aa88622f"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"

    dir = buildpath/"src/github.com/AdguardTeam/AdGuardHome"
    dir.install buildpath.children

    resource("packr").stage { system "go", "install", "./packr" }

    cd dir do
      system "npm", "--prefix", "client", "install"
      system "npm", "--prefix", "client", "run", "build-prod"

      system buildpath/"bin/packr", "-z"
      system "go", "build", "-ldflags", "-s -w -X main.version=#{version}"
      bin.install "AdGuardHome"

      (etc/"adguard-home").mkpath
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    On the first run, you have to go through the initial configuration
    wizard. Open your web browser and go to:
      http://127.0.0.1:3000

    After starting and configuring AdGuardHome, you will need to point your
    local DNS server to 127.0.0.1. You can do this by going to
    System Preferences > "Network" and clicking the "Advanced..."
    button for your interface. You will see a "DNS" tab where you
    can click "+" and enter 127.0.0.1 in the "DNS Servers" section.
    By default, AdGuardHome runs on localhost (127.0.0.1), port 53,
    balancing traffic across a set of resolvers.
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
          <string>#{bin}/AdGuardHome</string>
          <string>-c</string>
          <string>#{etc}/adguard-home/AdGuardHome.yaml</string>
          <string>-w</string>
          <string>#{etc}/adguard-home</string>
          <string>--no-check-update</string>
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
    begin
      require "socket"

      server = TCPServer.new(0)
      http_port = server.addr[1]
      server.close

      server = TCPServer.new(0)
      dns_port = server.addr[1]
      server.close

      expected_output_re = /ns\d+\.google\.com\./

      (testpath/"AdGuardHome.yaml").write <<~EOS
        bind_host: localhost
        bind_port: #{http_port}
        dns:
          bind_host: localhost
          port: #{dns_port}
          bootstrap_dns:
            - '1.1.1.1'
      EOS

      pid = fork do
        exec bin/"AdGuardHome", "-w", "#{testpath}", "-c", "#{testpath}/AdGuardHome.yaml", "--pidfile", "#{testpath}/httpd.pid"
      end
      sleep 3

      assert_block do
        shell_output("dig @127.0.0.1 -p #{dns_port} google.com NS +short").split("\n").all? { |ns| ns =~ expected_output_re }
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
