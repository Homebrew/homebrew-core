class PcapDnsproxy < Formula
  desc "Powerful DNS proxy designed to anti DNS spoofing"
  homepage "https://github.com/chengr28/Pcap_DNSProxy"
  url "https://github.com/chengr28/Pcap_DNSProxy/archive/v0.4.9.4.tar.gz"
  sha256 "9d2f6026d05dbfb8795cec0a4341b7d947c6abe4280353bdcf4793679ec296f2"
  head "https://github.com/chengr28/Pcap_DNSProxy.git"

  bottle do
    sha256 "7337e46d912c456226fab7b2dd4a8fcf0177b3ae33d2ee399e0fac2699dbcb06" => :high_sierra
    sha256 "2d85db3f80aac3176b7ec3586bcce6b7c0bbdd9c5f3d1811e35bbcde8ee067ec" => :sierra
    sha256 "7e11e06790b5d64095e176595936771d6f14e3aa95ed92688368345eb06a398e" => :el_capitan
  end

  depends_on :macos => :el_capitan
  depends_on :xcode => :build
  depends_on "libsodium"
  depends_on "openssl@1.1"

  def install
    (buildpath/"Source/Dependency/LibSodium").install_symlink Formula["libsodium"].opt_lib/"libsodium.a" => "LibSodium_macOS.a"
    (buildpath/"Source/Dependency/OpenSSL").install_symlink Formula["openssl@1.1"].opt_lib/"libssl.a" => "LibSSL_macOS.a"
    (buildpath/"Source/Dependency/OpenSSL").install_symlink Formula["openssl@1.1"].opt_lib/"libcrypto.a" => "LibCrypto_macOS.a"
    xcodebuild "-project", "./Source/Pcap_DNSProxy.xcodeproj", "-target", "Pcap_DNSProxy", "-configuration", "Release", "SYMROOT=build"
    bin.install "Source/build/Release/Pcap_DNSProxy"
    (etc/"pcap_dnsproxy").install Dir["Source/Auxiliary/ExampleConfig/*.{ini,txt}"]
    prefix.install "Source/Auxiliary/ExampleConfig/pcap_dnsproxy.service.plist"
  end

  plist_options :startup => true, :manual => "sudo #{HOMEBREW_PREFIX}/opt/pcap_dnsproxy/bin/Pcap_DNSProxy -c #{HOMEBREW_PREFIX}/etc/pcap_dnsproxy/"

  test do
    (testpath/"pcap_dnsproxy").mkpath
    cp Dir[etc/"pcap_dnsproxy/*"], testpath/"pcap_dnsproxy/"

    inreplace testpath/"pcap_dnsproxy/Config.ini" do |s|
      s.gsub! /^Direct Request.*/, "Direct Request = IPv4 + IPv6"
      s.gsub! /^Operation Mode.*/, "Operation Mode = Proxy"
      s.gsub! /^Listen Port.*/, "Listen Port = 9999"
    end

    pid = fork { exec bin/"Pcap_DNSProxy", "-c", testpath/"pcap_dnsproxy/" }
    begin
      system "dig", "google.com", "@127.0.0.1", "-p", "9999", "+short"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
