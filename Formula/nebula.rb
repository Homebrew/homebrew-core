class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.4.0.tar.gz"
  sha256 "e8d79231f6100a2cd240d6a092d0dcc2bfccadffa83cb40e99b7328f6c75c2ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "227c21ce7bc1df21cfbc32e5ddc9183d47fbb948f822ebada84a5fe85b9ea70c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c22fa740a6bcbebfa2c66a2983cb1c4be85ab26f3e94744d7d2216769e836c79"
    sha256 cellar: :any_skip_relocation, catalina:      "6b4e35987bd0fbc8a44248e1c6c8463945bf5775700856400af492e598aac565"
    sha256 cellar: :any_skip_relocation, mojave:        "443bf8ec9c2c4a7a40e49320ff7da810bed35fe599a62618820d7f97443744c6"
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
