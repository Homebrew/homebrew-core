class Bitlbee < Formula
  desc "IRC to other chat networks gateway"
  homepage "https://www.bitlbee.org/"
  revision 1
  head "https://github.com/bitlbee/bitlbee.git"

  stable do
    url "https://get.bitlbee.org/src/bitlbee-3.5.1.tar.gz"
    sha256 "9636d7fd89ebb3756c13a9a3387736ca6d56ccf66ec0580d512f07b21db0fa69"

    # Fixes a couple of bugs/potential crashes.
    patch do
      url "https://github.com/bitlbee/bitlbee/commit/17a58dfa.patch?full_index=1"
      sha256 "3a5729fd68bedabd1df717124e1950897eaee9feaf8237f6d67746e73df6cc6b"
    end

    patch do
      url "https://github.com/bitlbee/bitlbee/commit/eb73d05e.patch?full_index=1"
      sha256 "a54bdc82ff2959992e081586f5dd478a1719cd5037ebb0bfa54db6013853e0a5"
    end
  end

  bottle do
    sha256 "fb83f16110761697d99f8c19fc71b0698909afe952c8528257ebce7d2f36a59d" => :catalina
    sha256 "d098e0cc8717fd8bdac6b0e4fc358d7414193a16df4e14dfe7ee41699afc1c23" => :mojave
    sha256 "9a0f8d1791dfbfcbd63c833b756be5552db2c6bf961a852ad1973691eef644d4" => :high_sierra
    sha256 "4649e401630a5b1ed750d1a9a1806b90e3d57bb6f65133755b77ebf254d58dec" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"

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

  def plist; <<~EOS
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
