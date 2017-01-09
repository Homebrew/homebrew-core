class Bitlbee < Formula
  desc "IRC to other chat networks gateway"
  homepage "https://www.bitlbee.org/"
  url "https://get.bitlbee.org/src/bitlbee-3.5.tar.gz"
  sha256 "549d02181ab303dfe8a219faafd7a1aea7ee642eb071b767f668782a57388319"

  head "https://github.com/bitlbee/bitlbee.git"

  bottle do
    rebuild 1
    sha256 "22f5da46c5b88ef3b966d41d8432c51e5c00885f04a8c7c51544fc95e7607754" => :sierra
    sha256 "ef4a9a2997b74d26c49c72fb31ff7a17e3dee672021affaf73329681c44cb804" => :el_capitan
    sha256 "dbac12a0c0d7d38ab4235ad177194fec0c40a5e13301aefef729bae4b22f2db7" => :yosemite
  end

  option "with-pidgin", "Use finch/libpurple for all communication with instant messaging networks"
  option "with-libotr", "Build with otr (off the record) support"
  option "with-libevent", "Use libevent for the event-loop handling rather than glib."

  deprecated_option "with-finch" => "with-pidgin"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "pidgin" => :optional
  depends_on "libotr" => :optional
  depends_on "libevent" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --plugindir=#{HOMEBREW_PREFIX}/lib/bitlbee/
      --debug=0
      --ssl=gnutls
      --pidfile=#{var}/bitlbee/run/bitlbee.pid
      --config=#{var}/bitlbee/lib/
      --ipsocket=#{var}/bitlbee/run/bitlbee.sock
    ]

    args << "--purple=1" if build.with? "pidgin"
    args << "--otr=1" if build.with? "libotr"
    args << "--events=libevent" if build.with? "libevent"

    system "./configure", *args

    # This build depends on make running first.
    system "make"
    system "make", "install"
    # Install the dev headers too
    system "make", "install-dev"
    # This build has an extra step.
    system "make", "install-etc"

    (var/"bitlbee/run").mkpath
    (var/"bitlbee/lib").mkpath
  end

  plist_options :manual => "bitlbee -D"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>OnDemand</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/bitlbee</string>
      </array>
      <key>ServiceDescription</key>
      <string>bitlbee irc-im proxy</string>
      <key>Sockets</key>
      <dict>
        <key>Listener</key>
        <dict>
          <key>SockFamily</key>
          <string>IPv4</string>
          <key>SockProtocol</key>
          <string>TCP</string>
          <key>SockNodeName</key>
          <string>127.0.0.1</string>
          <key>SockServiceName</key>
          <string>6667</string>
          <key>SockType</key>
          <string>stream</string>
        </dict>
      </dict>
      <key>inetdCompatibility</key>
      <dict>
        <key>Wait</key>
        <false/>
      </dict>
    </dict>
    </plist>
    EOS
  end

  test do
    shell_output("#{sbin}/bitlbee -V", 1)
  end
end
