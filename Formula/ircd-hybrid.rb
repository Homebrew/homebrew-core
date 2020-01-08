class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "http://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.24/ircd-hybrid-8.2.24.tgz"
  sha256 "eaa42d8bf10c0e619e3bda96f35d31bb20715305a85a1386cfbc6b8761fed50e"
  revision 1

  bottle do
    sha256 "de9ce625b777bf066d1d0b2933443618b677fe74387f7a3d2f07ff856605f1c0" => :catalina
    sha256 "478efdf1f24ce2baa47511c4cfa2c451703140c760186a8845fecc765c3b38c4" => :mojave
    sha256 "36d3e9d28b01f104593703ebe93a230a170247090e78b492cee72eb55c3cedcc" => :high_sierra
    sha256 "f61894f34fb608a97f4df370f9f466a129f418d8eb48781fe936ff5f145c2c5a" => :sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "ircd-irc2", :because => "both install an `ircd` binary"

  # ircd-hybrid needs the .la files
  skip_clean :la

  def install
    ENV.deparallelize # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
    etc.install "doc/reference.conf" => "ircd.conf"
  end

  def caveats; <<~EOS
    You'll more than likely need to edit the default settings in the config file:
      #{etc}/ircd.conf
  EOS
  end

  plist_options :manual => "ircd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <false/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/ircd</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/ircd.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/ircd", "-version"
  end
end
