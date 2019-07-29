class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "http://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.24/ircd-hybrid-8.2.24.tgz"
  sha256 "eaa42d8bf10c0e619e3bda96f35d31bb20715305a85a1386cfbc6b8761fed50e"

  bottle do
    sha256 "019444c3b32e17ec5dab9f9a7697b2cceda280d2af447b4f56271082e98a2438" => :mojave
    sha256 "a3c6846e6cdad9e8615f01d1539b857a4a02aa87b475f0b7e576c29716f9b4e2" => :high_sierra
    sha256 "1be9a361ecfcadda2db262d7af21b3a4518fa2dbb1400fc9b6bfd21e3b080949" => :sierra
    sha256 "cb2919d989ee6ae1fa2ed37b4cdc24ff32d10512d436ec29d47218b75ab3f3a3" => :el_capitan
  end

  depends_on "openssl"

  conflicts_with "ircd-irc2", :because => "both install an `ircd` binary"

  # ircd-hybrid needs the .la files
  skip_clean :la

  def install
    ENV.deparallelize # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-openssl=#{Formula["openssl"].opt_prefix}"
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
