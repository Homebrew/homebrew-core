class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.3.0.tar.gz"
  sha256 "b94fba0251a4a436e25b127d0b9bc0181b991631f1dc8e344b1c8e895b55375d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "53f7fede666f8aac491e27c6e3118c61fa32cc0ac0bbc5f114a81e492049b8f4" => :big_sur
    sha256 "6101a001b38d3d6379abbfc06e986dc01e14ecf31ba5e3218a8d7ce8f6e267c0" => :arm64_big_sur
    sha256 "7ffeb1007dd970546c484ac5f2a3f7cc8f8e4c91624d8bbc9ed22dcca5cce478" => :catalina
    sha256 "41f78ae9272360e99b8cc89931f8a26ac5a189cfa653679a06b78a0fd4adedd6" => :mojave
    sha256 "bcf0c677c2a13a1e937625bf73b1e437dc3d1ae520a6a96cc798721cd18769f9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "bin"
    bin.install "./nebula"
    bin.install "./nebula-cert"
    prefix.install_metafiles
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/nebula</string>
          <string>-config</string>
          <string>#{etc}/nebula/config.yml</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/nebula.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/nebula.log</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/nebula-cert", "ca", "-name", "testorg"
    system "#{bin}/nebula-cert", "sign", "-name", "host", "-ip", "192.168.100.1/24"
    (testpath/"config.yml").write <<~EOS
      pki:
        ca: #{testpath}/ca.crt
        cert: #{testpath}/host.crt
        key: #{testpath}/host.key
    EOS
    system "#{bin}/nebula", "-test", "-config", "config.yml"
  end
end
