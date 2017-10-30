class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "http://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.22/ircd-hybrid-8.2.22.tgz"
  sha256 "d7d8df4524d088132e928d3685f2f65bb7b1bf6c1f855fc9e16a3dc460d9b1c4"

  bottle do
    sha256 "4dec65cb5a6b48e2fd47955ac68162ce6c8e588b1941313ba6c899f49128dac8" => :high_sierra
    sha256 "cc93ca913142492805fe559b934b90faa291f3ec36563bce9e9687350f7a921f" => :sierra
    sha256 "eee3efa1fd78d82aeff072c0d46a078b06919dfa0e7225ffe4d43e668f589cf2" => :el_capitan
    sha256 "b9cbc2bd21180405b48865a3d4bc82d3dc534cb1936a4f9fe49148453e2eece4" => :yosemite
  end

  # ircd-hybrid needs the .la files
  skip_clean :la

  depends_on "openssl"

  conflicts_with "ircd-irc2", :because => "both install an `ircd` binary"

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
