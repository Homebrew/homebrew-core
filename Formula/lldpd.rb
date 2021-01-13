class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.8.tar.gz"
  sha256 "98d200e76e30f6262c4a4493148c1840827898329146a57a34f8f0f928ca3def"
  license "ISC"

  livecheck do
    url "https://github.com/vincentbernat/lldpd.git"
  end

  bottle do
    sha256 "5d984d695c1fd07140da9eb2076e859339ccee48e132a6f76a6272c8be5a116a" => :big_sur
    sha256 "33cc78b7d89fd79e666e13d6ea373be0ed21b691b7f617eaafe0d9fb0bd93539" => :arm64_big_sur
    sha256 "b4445feaa32fb902e0619923d19c0368be1ec4a1f6ce24d6933e03d5b5e0b21f" => :catalina
    sha256 "59afd24eb756f886e6c8b8d357bbff4bb1becb22b98fea94986ff287964f8d6f" => :mojave
    sha256 "944ba7de01a2f0eb90536b7bd711f077c39a1a608b240d466f53eb40b4c17214" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    readline = Formula["readline"]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-launchddaemonsdir=no
      --with-privsep-chroot=/var/empty
      --with-privsep-group=nogroup
      --with-privsep-user=nobody
      --with-readline
      --with-xml
      --without-snmp
      CPPFLAGS=-I#{readline.include}\ -DRONLY=1
      LDFLAGS=-L#{readline.lib}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/lldpd</string>
        </array>
        <key>RunAtLoad</key><true/>
        <key>KeepAlive</key><true/>
      </dict>
      </plist>
    EOS
  end
end
