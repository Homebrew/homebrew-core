class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.0.tar.gz"
  sha256 "13b09f43f530c6e9eec8ead0493e1b34f332b8ead89e46623e1fc40bb137b80d"

  bottle do
    sha256 "81025c4772690791e2dc89fb7504ee0291b87e70cf756db2b291f2d456e54321" => :high_sierra
    sha256 "5b841afd2f111884900614bc6e933a197f3bd5b0822699b320482191debce43e" => :sierra
    sha256 "cc07be2c740f9a9fa8ff493de2956b5443f095517c2eb962af72c6a89066a595" => :el_capitan
  end

  option "with-snmp", "Build SNMP subagent support"

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "libevent"
  depends_on "net-snmp" if build.with? "snmp"

  def install
    readline = Formula["readline"]
    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{etc}",
      "--localstatedir=#{var}",
      "--with-xml",
      "--with-readline",
      "--with-privsep-chroot=/var/empty",
      "--with-privsep-user=nobody",
      "--with-privsep-group=nogroup",
      "--with-launchddaemonsdir=no",
      "CPPFLAGS=-I#{readline.include} -DRONLY=1",
      "LDFLAGS=-L#{readline.lib}",
    ]
    args << (build.with?("snmp") ? "--with-snmp" : "--without-snmp")

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
