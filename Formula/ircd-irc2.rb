class IrcdIrc2 < Formula
  desc "Original IRC server daemon"
  homepage "http://www.irc.org/"
  url "http://www.irc.org/ftp/irc/server/irc2.11.2p3.tgz"
  version "2.11.2p3"
  sha256 "be94051845f9be7da0e558699c4af7963af7e647745d339351985a697eca2c81"

  bottle do
    sha256 "8508a48308449f51d7190eccc640b9351de2d30379b99b4fe0595cb185458204" => :catalina
    sha256 "81e5c21532c98066b89bddc0ec6285eba22d2fcfb2c620b00ada8a6f4d641c7f" => :mojave
    sha256 "ebc4e1007b994ae418cd522ecc70fa2c738dbf7eb52a883f775e7dcc9b06892e" => :high_sierra
    sha256 "72b85345931772dc3ac1fe96201906db0c70c24e129e9ee7006253080926bd2f" => :sierra
    sha256 "259ddceb29a5d5e0705c3b0a130368053de98282ecec2036c17d30062bd6f9f4" => :el_capitan
    sha256 "af6c845d852e4a525d64f1cfbd551377c90da201c2ef3e521d48fc1513a58064" => :yosemite
    sha256 "9fd885d98218c6e570f16b238cb72546130f5ca1bbe2e06f260b7a672dba02e2" => :mavericks
  end

  def default_ircd_conf
    <<~EOS
      # M-Line
      M:irc.localhost::Darwin ircd default configuration::000A

      # A-Line
      A:This is Darwin's default ircd configurations:Please edit your /usr/local/etc/ircd.conf file:Contact <root@localhost> for questions::ExampleNet

      # Y-Lines
      Y:1:90::100:512000:5.5:100.100
      Y:2:90::300:512000:5.5:250.250

      # I-Line
      I:*:::0:1
      I:127.0.0.1/32:::0:1

      # P-Line
      P::::6667:
    EOS
  end

  conflicts_with "ircd-hybrid", :because => "both install `ircd` binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "CFLAGS=-DRLIMIT_FDMAX=0"

    build_dir = `./support/config.guess`.chomp

    # Disable netsplit detection. In a netsplit, joins to new channels do not
    # give chanop status.
    inreplace "#{build_dir}/config.h", /#define DEFAULT_SPLIT_USERS\s+65000/,
      "#define DEFAULT_SPLIT_USERS 0"
    inreplace "#{build_dir}/config.h", /#define DEFAULT_SPLIT_SERVERS\s+80/,
      "#define DEFAULT_SPLIT_SERVERS 0"

    # The directory is something like `i686-apple-darwin13.0.2'
    system "make", "install", "-C", build_dir

    (etc/"ircd.conf").write default_ircd_conf
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
          <string>#{opt_sbin}/ircd</string>
          <string>-t</string>
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
    system "#{sbin}/ircd", "-version"
  end
end
