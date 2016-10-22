class PcapDnsproxy < Formula
  desc "Powerful DNS proxy designed to anti DNS spoofing"
  homepage "https://github.com/chengr28/Pcap_DNSProxy"
  url "https://github.com/chengr28/Pcap_DNSProxy/archive/v0.4.7.7.tar.gz"
  sha256 "711f56e39535610e4b5fc174437a9572ef1a8e982207d0e7d0e5ed4b8eaf3f8e"
  head "https://github.com/chengr28/Pcap_DNSProxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a09961365b54ad86e40272c283e0e70b7efb6b20d41661788d13dad54ab2b7b" => :sierra
    sha256 "8cdb6f4f1f300798d5525efeed9a90c7d999f1aa4c7f5777f7be6e6d8da52101" => :el_capitan
    sha256 "9ffea6ca6c85205ec396a1b65f5311d31fff8fd250428e493d04bece593af94c" => :yosemite
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
