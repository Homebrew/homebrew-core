class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.1.tar.gz"
  sha256 "450b622aac7ae1758f1ef82f3b7b94ec47f2ff33abfb0e6ac82555b9ee55f151"

  bottle do
    sha256 "1c66fc798da96bf31629f986bb396e91a81541087b833b6adb59a98919b4819d" => :mojave
    sha256 "d770ef1c3507d3d2373f8706acf4f8d3c41ae07f594192db02483184e497c510" => :high_sierra
    sha256 "fd38d0022374f5960183ec7afde1a5c9ffc85047c017a667f09b92cda25b1c7a" => :sierra
    sha256 "1158b121a76df10a688d9907ab0843886ce7798f6d54ad8eaf9d21b17cb7b01f" => :el_capitan
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
