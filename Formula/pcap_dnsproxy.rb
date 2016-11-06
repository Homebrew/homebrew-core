class PcapDnsproxy < Formula
  desc "Powerful DNS proxy designed to anti DNS spoofing"
  homepage "https://github.com/chengr28/Pcap_DNSProxy"
  url "https://github.com/chengr28/Pcap_DNSProxy/archive/v0.4.7.8.tar.gz"
  sha256 "57af22d8688cd23e74e5eee0b716ea0c8e68671d3be34ef993df7b8303aa73d0"
  head "https://github.com/chengr28/Pcap_DNSProxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e57474daffe1964ff3cb9eac846409071f50d8dd77705245ebf9756ef738c14" => :sierra
    sha256 "6e05175edb71f9fa67a31bb764d35e391619fc027be4c454d373313a1143b434" => :el_capitan
    sha256 "29a1833a46e048081ad788f50ddb57424e6ff2725c45424861d51c557bf5b222" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on :xcode => :build
  depends_on "libsodium"

  def install
    (buildpath/"Source/LibSodium").install_symlink Formula["libsodium"].opt_lib/"libsodium.a" => "LibSodium_Mac.a"
    xcodebuild "-project", "./Source/Pcap_DNSProxy.xcodeproj", "-target", "Pcap_DNSProxy", "-configuration", "Release", "SYMROOT=build"
    bin.install "Source/build/Release/Pcap_DNSProxy"
    (etc/"pcap_DNSproxy").install Dir["Source/ExampleConfig/*.{ini,txt}"]
  end

  plist_options :startup => true, :manual => "sudo #{HOMEBREW_PREFIX}/opt/pcap_dnsproxy/bin/Pcap_DNSProxy -c #{HOMEBREW_PREFIX}/etc/pcap_dnsproxy/"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/Pcap_DNSProxy</string>
          <string>-c</string>
          <string>#{etc}/pcap_dnsproxy/</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"pcap_DNSproxy").mkpath
    cp Dir[etc/"pcap_DNSproxy/*"], testpath/"pcap_DNSproxy/"

    inreplace testpath/"pcap_DNSproxy/Config.ini" do |s|
      s.gsub! /^Direct Request.*/, "Direct Request = IPv4 + IPv6"
      s.gsub! /^Operation Mode.*/, "Operation Mode = Proxy"
      s.gsub! /^Listen Port.*/, "Listen Port = 9999"
    end

    pid = fork { exec bin/"Pcap_DNSProxy", "-c", testpath/"pcap_DNSproxy/" }
    begin
      system "dig", "google.com", "@127.0.0.1", "-p", "9999", "+short"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
