class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "http://www.thekelleys.org.uk/dnsmasq/doc.html"
  url "http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.81.tar.gz"
  sha256 "3c28c68c6c2967c3a96e9b432c0c046a5df17a426d3a43cffe9e693cf05804d0"
  license "GPL-2.0"

  bottle do
    sha256 "e46052d3d5ae49135b80d383a9d891d58148f47a62ccd054633614ce02c35ed6" => :catalina
    sha256 "773bdf846730a553e63613d73f9488f3d946b2cd3fdc024fa2d9dbd6d659b09f" => :mojave
    sha256 "ff6cfbbe9a2bb3caf6e079d62db676f459c882bff835717dbfc443ec920cfe77" => :high_sierra
  end

  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace %w[dnsmasq.conf.example src/config.h man/dnsmasq.8
                 man/es/dnsmasq.8 man/fr/dnsmasq.8].each do |s|
      s.gsub! "/var/lib/misc/dnsmasq.leases",
              var/"lib/misc/dnsmasq/dnsmasq.leases", false
      s.gsub! "/etc/dnsmasq.conf", etc/"dnsmasq.conf", false
      s.gsub! "/var/run/dnsmasq.pid", var/"run/dnsmasq/dnsmasq.pid", false
      s.gsub! "/etc/dnsmasq.d", etc/"dnsmasq.d", false
      s.gsub! "/etc/ppp/resolv.conf", etc/"dnsmasq.d/ppp/resolv.conf", false
      s.gsub! "/etc/dhcpc/resolv.conf", etc/"dnsmasq.d/dhcpc/resolv.conf", false
      s.gsub! "/usr/sbin/dnsmasq", HOMEBREW_PREFIX/"sbin/dnsmasq", false
    end

    # Fix compilation on newer macOS versions.
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542"

    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "LDFLAGS", ENV.ldflags
    end

    system "make", "install", "PREFIX=#{prefix}"

    etc.install "dnsmasq.conf.example" => "dnsmasq.conf"
  end

  def post_install
    (var/"lib/misc/dnsmasq").mkpath
    (var/"run/dnsmasq").mkpath
    (etc/"dnsmasq.d/ppp").mkpath
    (etc/"dnsmasq.d/dhcpc").mkpath
    touch etc/"dnsmasq.d/ppp/.keepme"
    touch etc/"dnsmasq.d/dhcpc/.keepme"
  end

  plist_options :startup => true

  def plist
    <<~EOS
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
            <string>-7</string>
            <string>#{etc}/dnsmasq.d,*.conf</string>
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
