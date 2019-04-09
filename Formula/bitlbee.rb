class Bitlbee < Formula
  desc "IRC to other chat networks gateway"
  homepage "https://www.bitlbee.org/"
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
    sha256 "4e397710ecbbb772f346151ea9c99dd2b5a80e05bf93d4f0be2e23fb21e1bbea" => :mojave
    sha256 "75272001af19553b23bd5d999c76570e9f53c5f0386fe8377f4e8af6e525fb50" => :high_sierra
    sha256 "a73fcc3ea892e02dff11eda82c9338230f16778d786dbcfecae89802fb0859cb" => :sierra
    sha256 "f1e4ace83358ed1164d5d8cfbe7ffe239b5698d24211150b86dbf4d4fb589a37" => :el_capitan
    sha256 "85eebf3ba9ee2e986ef1c54b99a8df958cf48a1d5112f765e5498d9be23b9426" => :yosemite
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
