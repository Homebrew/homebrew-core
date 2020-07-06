class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "http://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.31/ircd-hybrid-8.2.31.tgz"
  sha256 "ab8dbd2152cb9c7f228d1efa9f9f1c1e3fc545959c9a9df0dc3ebb1e087d708f"
  license "GPL-2.0"

  bottle do
    sha256 "547457f864424055dca2cea8503012e2b9847aebbc1ee21fda02100d357cef3e" => :catalina
    sha256 "abce429d77cb8c9949cd25f1c3560642eadf264906d05340779acea9e92c35dd" => :mojave
    sha256 "444b6c2610188e971e583200ed8f243ce1609682690cd8e1775b9b98321f2f48" => :high_sierra
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

  def caveats
    <<~EOS
      You'll more than likely need to edit the default settings in the config file:
        #{etc}/ircd.conf
    EOS
  end

  plist_options :manual => "ircd"

  def plist
    <<~EOS
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
