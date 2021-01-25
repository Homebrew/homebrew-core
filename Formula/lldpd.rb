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
    sha256 "9c55269d6b7bac30bd47b0733056f87c4aa7e38a44b55b806aae7ef3cc270ffc" => :big_sur
    sha256 "015c4c0324661d90e06436a348dfc37af918e7bbea32ee63e2db58469a5a230e" => :arm64_big_sur
    sha256 "9c82d5c9c454ce3cd453b379e31bd79922ebe5e0b7377c6e845cb039ca3fddf1" => :catalina
    sha256 "2f35d49b7ca199a2980f08816bc055cfec43f29b0c2c55a05cb55dcc72b9ccea" => :mojave
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
