class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.1.tar.gz"
  sha256 "450b622aac7ae1758f1ef82f3b7b94ec47f2ff33abfb0e6ac82555b9ee55f151"
  revision 1

  bottle do
    rebuild 1
    sha256 "8222ab9826ddcdad598d354c001d064fe92aa386b8088464c29fdc2cb0a08757" => :mojave
    sha256 "c5ba1d60ebad77d94fd21fe743bd62f99e08ef364ab0ca3b9c852d4be531ff51" => :high_sierra
    sha256 "0bcede6bdf6809586f730d2938f9e17a508c43baac194fc36e24fb9b7d54f9aa" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "readline"

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

  plist_options :startup => true

  def plist
    additional_args = ""
    additional_args += "<string>-x</string>" if build.with? "snmp"
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
          #{additional_args}
        </array>
        <key>RunAtLoad</key><true/>
        <key>KeepAlive</key><true/>
      </dict>
      </plist>
    EOS
  end
end
