class PcapDnsproxy < Formula
  desc "Powerful DNS proxy designed to anti DNS spoofing"
  homepage "https://github.com/chengr28/Pcap_DNSProxy"
  url "https://github.com/chengr28/Pcap_DNSProxy/archive/v0.4.8.6.tar.gz"
  sha256 "a6c9c2adc911756f460f8bb9ba6c79de29a6de50fd73de03bbc67af9d8ff97eb"
  head "https://github.com/chengr28/Pcap_DNSProxy.git"

  bottle do
    sha256 "addff90b1ba84293b545778b055448e4ab6fa45f753b79c3e392d9e9d30fa1b0" => :sierra
    sha256 "1c462cda06356957500baf934c508d263114575fe5368061d204b1c7b1e50b3f" => :el_capitan
    sha256 "5ad62a89c78c853de0181efaf10af9f3e25a18130dfa467a848fbc19c18c8c9b" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on :xcode => :build
  depends_on "libsodium"
  depends_on "openssl@1.1"

  def install
    (buildpath/"Source/Dependency/LibSodium").install_symlink Formula["libsodium"].opt_lib/"libsodium.a" => "LibSodium_macOS.a"
    (buildpath/"Source/Dependency/OpenSSL").install_symlink Formula["openssl@1.1"].opt_lib/"libssl.a" => "LibSSL_macOS.a"
    (buildpath/"Source/Dependency/OpenSSL").install_symlink Formula["openssl@1.1"].opt_lib/"libcrypto.a" => "LibCrypto_macOS.a"
    xcodebuild "-project", "./Source/Pcap_DNSProxy.xcodeproj", "-target", "Pcap_DNSProxy", "-configuration", "Release", "SYMROOT=build"
    bin.install "Source/build/Release/Pcap_DNSProxy"
    (etc/"pcap_DNSproxy").install Dir["Source/Auxiliary/ExampleConfig/*.{ini,txt}"]
    prefix.install "Source/Auxiliary/ExampleConfig/pcap_dnsproxy.service.plist"
  end

  plist_options :startup => true, :manual => "sudo #{HOMEBREW_PREFIX}/opt/pcap_dnsproxy/bin/Pcap_DNSProxy -c #{HOMEBREW_PREFIX}/etc/pcap_DNSproxy/"

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
