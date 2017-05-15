class Bitlbee < Formula
  desc "IRC to other chat networks gateway"
  homepage "https://www.bitlbee.org/"
  head "https://github.com/bitlbee/bitlbee.git"

  stable do
    url "https://get.bitlbee.org/src/bitlbee-3.5.1.tar.gz"
    sha256 "9636d7fd89ebb3756c13a9a3387736ca6d56ccf66ec0580d512f07b21db0fa69"

    # Fixes a couple of bugs/potential crashes.
    patch do
      url "https://github.com/bitlbee/bitlbee/commit/17a58dfa.patch"
      sha256 "2eab8a84eac25d3e5630e7da8cbd45f6e6a2e0d70d0dac111c8b0053b73cab68"
    end

    patch do
      url "https://github.com/bitlbee/bitlbee/commit/eb73d05e.patch"
      sha256 "0bdf1478f21b666cf1df194d05be7bcaf9b7d6d1ce3c99ac90563288e3c30935"
    end
  end

  bottle do
    sha256 "25e0fccb21f49326295ef5b24de1b6001ebb60e82f7dfad58ea1b14753aa7006" => :sierra
    sha256 "9f2fe2cde9e8282312eeeea3b694f94d6669ece67a653156c93270f9b6d8f1cb" => :el_capitan
    sha256 "7d1a271ad5feff5e3a5c3beadc4371e648218ee230547d59c9346471451f8c2b" => :yosemite
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
      --etcdir=#{etc}/bitlbee
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
  end

  def post_install
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
    assert_match version.to_s, shell_output("#{sbin}/bitlbee -V", 1)
  end
end
