class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.2.0.tar.gz"
  sha256 "1d00594d74e147406f5809380860f538ceed5c19c3f390dd1d8e364f99b303b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d3c7165792a6af1ca242ad8cb2e1466eb2ed29973f0b0a303cc1b995389a7d8" => :catalina
    sha256 "3da3e3c250ab1727bff0b22c0d84daa4d6ea52d113b46626d6990bdc046cdfd2" => :mojave
    sha256 "f82f0b0f5d11c9b5e82ee2719270f9a5260689c75fe4074e499c3891b0a177bd" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "bin"
    bin.install "./nebula"
    bin.install "./nebula-cert"
    prefix.install_metafiles
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
