class PcapDnsproxy < Formula
  desc "Powerful DNS proxy designed to anti DNS spoofing"
  homepage "https://github.com/chengr28/Pcap_DNSProxy"
  url "https://github.com/chengr28/Pcap_DNSProxy/archive/v0.4.7.0.tar.gz"
  sha256 "48e92a3c9073047140e6b171c2b2d2bdc50af6b308ade0a131e233cfe8d12e8e"
  head "https://github.com/chengr28/Pcap_DNSProxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d030e72d4c358d7ad02d7490b0419767f4457429fc47ec02d996584ed2452750" => :el_capitan
    sha256 "c825c32e556b3742359fff8284fcf7734bae731ad675ba4bb6512e48e80a37b5" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on :xcode => :build

  def install
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
