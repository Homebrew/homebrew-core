class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.11.tar.gz"
  sha256 "b51d15700fbaefcb7fb85c3506b49d33173a0f15d700f933ef044067b42d46e4"
  license "ISC"

  livecheck do
    url "https://github.com/vincentbernat/lldpd.git"
  end

  bottle do
    sha256 arm64_big_sur: "9aa7753ca04624756238d5067494d09d9bde797034dca7321f3f4868c6d05c48"
    sha256 big_sur:       "ae966214024578b49cc642d8fbd141446d3321b3ce3a6ef360db2b9acda5509d"
    sha256 catalina:      "e34ca3a997738dcf2e0d3fa8a549c6c503a9e8119c2173293c0de24c612c4873"
    sha256 mojave:        "9e72bb2d06eb3035026d4c3731c1fc71e72e9fe18009ed89b1946eea7ac6c390"
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
