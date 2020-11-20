class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.35/ircd-hybrid-8.2.35.tgz"
  sha256 "8a5d2eb98c48d01a9cf2f9bd554aa3e0e44291547a2a47e2a13044a2f868bc10"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "b3b4c8073a2c5258b7fa57a194c2ce33a00ad167a5f5a824853fe23ff7d7bd6f" => :big_sur
    sha256 "fd198e99459ec5f6c3f10fbd10dd95fec4064fa0b6fc79407f517f59d0f1e602" => :catalina
    sha256 "290c563e7ed4bcc10aedb0b38dda5a933e1b399f91cf64cc026c26bca556c078" => :mojave
    sha256 "19e587507da6c3fd66fa207129499cabe2a6114dde6288ddbdca84515da0e432" => :high_sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "ircd-irc2", because: "both install an `ircd` binary"

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

  plist_options manual: "ircd"

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
