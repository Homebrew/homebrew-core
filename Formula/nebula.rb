class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.2.0.tar.gz"
  sha256 "1d00594d74e147406f5809380860f538ceed5c19c3f390dd1d8e364f99b303b6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4a8afd93fe529dae21fdbd7a9fa25d0aee5411b1601563f660bbd4b539488645" => :catalina
    sha256 "71d30d68a8a92cd82a522348010020a358e50487571f0e147deb89d1afefdadb" => :mojave
    sha256 "ed3fa03a2fe956c9cf610d17a8df6b60e3d75508c15dc3fd46c47cd7decf2967" => :high_sierra
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
