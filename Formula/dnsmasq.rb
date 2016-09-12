class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "http://www.thekelleys.org.uk/dnsmasq/doc.html"
  url "http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.76.tar.gz"
  sha256 "777c4762d2fee3738a0380401f2d087b47faa41db2317c60660d69ad10a76c32"

  bottle do
    cellar :any_skip_relocation
    sha256 "98d0c8520998b8038c610e43db5fc2f215a164c02810718e6e508d4651f6f523" => :sierra
    sha256 "be3f214a1a48bee2aa64f8602d1227a1fb7f60ad7e30d1241b3e5b8410ec40b1" => :el_capitan
    sha256 "ff12dc78fd0b31297e333c991d37d8c1f6979d753755ddc8c09d5153cbf54a22" => :yosemite
    sha256 "56cfdbe6df3ecff3a6ccf444d8fd79fb234f2b566abc1a4a4631d960eb16851a" => :mavericks
  end

  option "with-libidn", "Compile with IDN support"
  option "with-dnssec", "Compile with DNSSEC support"

  deprecated_option "with-idn" => "with-libidn"

  depends_on "pkg-config" => :build
  depends_on "libidn" => :optional
  depends_on "nettle" if build.with? "dnssec"

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace "src/config.h", "/etc/dnsmasq.conf", "#{etc}/dnsmasq.conf"

    # Optional IDN support
    if build.with? "libidn"
      inreplace "src/config.h", "/* #define HAVE_IDN */", "#define HAVE_IDN"
    end

    # Optional DNSSEC support
    if build.with? "dnssec"
      inreplace "src/config.h", "/* #define HAVE_DNSSEC */", "#define HAVE_DNSSEC"
    end

    # Fix compilation on Lion
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542" if MacOS.version >= :lion
    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
    end

    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "dnsmasq.conf.example"
  end

  def caveats; <<-EOS.undent
    To configure dnsmasq, copy the example configuration to #{etc}/dnsmasq.conf
    and edit to taste.

      cp #{opt_prefix}/dnsmasq.conf.example #{etc}/dnsmasq.conf
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dnsmasq</string>
          <string>--keep-in-foreground</string>
          <string>-C</string>
          <string>#{etc}/dnsmasq.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{sbin}/dnsmasq", "--test"
  end
end
