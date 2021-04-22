class Launchdns < Formula
  desc "Mini DNS server designed solely to route queries to localhost"
  homepage "https://github.com/josh/launchdns"
  url "https://github.com/josh/launchdns/archive/v1.0.4.tar.gz"
  sha256 "60f6010659407e3d148c021c88e1c1ce0924de320e99a5c58b21c8aece3888aa"
  license "MIT"
  revision 2
  head "https://github.com/josh/launchdns.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "7b3d512057f002e8392874c78e3c24526b18af0c67627f7621b14abe43f1b627"
    sha256 cellar: :any_skip_relocation, catalina: "aa1aff83c3216221621ab07183258d6eac3b4662c7c22da75b4cee95465656eb"
    sha256 cellar: :any_skip_relocation, mojave:   "7e0a8422dce7c3af9dbc5f6a5d2c5ccd0ee77cac87c5e011af82e44402b9a216"
  end

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "--with-launch-h", "--with-launch-h-activate-socket"
    system "make", "install"

    (prefix/"etc/resolver/localhost").write("nameserver 127.0.0.1\nport 55353\n")
  end

  plist_options manual: "launchdns"

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
            <string>#{opt_bin}/launchdns</string>
            <string>--socket=Listeners</string>
            <string>--timeout=30</string>
          </array>
          <key>Sockets</key>
          <dict>
            <key>Listeners</key>
            <dict>
              <key>SockType</key>
              <string>dgram</string>
              <key>SockNodeName</key>
              <string>127.0.0.1</string>
              <key>SockServiceName</key>
              <string>55353</string>
            </dict>
          </dict>
          <key>StandardErrorPath</key>
          <string>#{var}/log/launchdns.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/launchdns.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    output = shell_output("#{bin}/launchdns --version")
    refute_match(/without socket activation/, output)
    system bin/"launchdns", "-p0", "-t1"
  end
end
