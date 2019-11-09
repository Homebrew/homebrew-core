class AdguardHome < Formula
  desc "Network-wide ads & trackers blocking DNS server"
  homepage "https://adguard.com/adguard-home.html"
  url "https://github.com/AdguardTeam/AdGuardHome.git",
      :tag      => "v0.98.1",
      :revision => "64d40bdc47081ed80e597e61e5c96953c1e35c30"
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
      system "make"
      bin.install "AdGuardHome"

      (etc/"adguard-home").mkpath
      prefix.install_metafiles
    end
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
      exec(
        bin/"AdGuardHome",
        "-w",
        testpath.to_s,
        "-c",
        "#{testpath}/AdGuardHome.yaml",
        "--pidfile",
        "#{testpath}/httpd.pid",
      )
    end
    sleep 3

    shell_output("dig @127.0.0.1 -p #{dns_port} google.com NS +short")
      .lines
      .each { |ns| assert_match expected_output_re, ns }
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
