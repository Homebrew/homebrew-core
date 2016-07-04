class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "http://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.18/ircd-hybrid-8.2.18.tgz"
  sha256 "8dcbd45a049dd4da03045bfa4833527555fdfdfce4e4637ee8b63abe6ae13405"

  bottle do
    sha256 "ba2c91d06c5a60b39c2101de3a51859ece7ce2d1a51505932e62b13d7c25f714" => :el_capitan
    sha256 "c910cc2c4abe4b2fcd98443c6d900499fe7fcda57a7069261b73af282d3fa543" => :yosemite
    sha256 "a6780c66f7fc1e44ed01a6de14f33886e0a679d9512bd5b8920ac770a7a9869c" => :mavericks
  end

  # ircd-hybrid needs the .la files
  skip_clean :la

  depends_on "openssl"

  conflicts_with "ircd-irc2", :because => "both install an `ircd` binary"

  def install
    ENV.j1 # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
    etc.install "doc/reference.conf" => "ircd.conf"
  end

  def caveats; <<-EOS.undent
    You'll more than likely need to edit the default settings in the config file:
      #{etc}/ircd.conf
    EOS
  end

  plist_options :manual => "ircd"

  def plist; <<-EOS.undent
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
