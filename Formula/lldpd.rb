class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.4.tar.gz"
  sha256 "5319bc032fabf1008d5d91e280276aa7f1bbfbb70129d8526cd4526d7c22724f"
  revision 1

  bottle do
    sha256 "e9a056129cde2e89fafc05704cfdaf0b59b4b4e7a4a84fc342600f47a5a2d540" => :mojave
    sha256 "a38c7dfd11897bb66d7e7ae648d6037221ca7c8055020bc8ca1b6630fc36e295" => :high_sierra
    sha256 "7ae0166c4d523d1b8d31792d2b160b47048c0a1096c7246ce652effc97f9df0f" => :sierra
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
