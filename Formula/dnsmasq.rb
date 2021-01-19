class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "https://www.thekelleys.org.uk/dnsmasq/doc.html"
  url "https://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.83.tar.gz"
  sha256 "6b67955873acc931bfff61a0a1e0dc239f8b52e31df50e9164d3a4537571342f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "http://www.thekelleys.org.uk/dnsmasq/"
    regex(/href=.*?dnsmasq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "d452e2a6562538d398ffa39c7a1761d222d613b2cbcadf5796a7dc2a25697d55" => :big_sur
    sha256 "fa45a739d36bf76d47b35d72ab36d8282abab1c7d5c920350f4532fa2fa970a3" => :arm64_big_sur
    sha256 "0cab9dbb88d09946faed36b09a1f0919141b3e56eea45e5f77969619e00796e0" => :catalina
    sha256 "c70c3fe42cdabac2497377e6718678eb5c433658ce1ea92e4193d6877d81c628" => :mojave
    sha256 "77e52871d7bd6af6f4f1e7b1d55bae2fa235c1d6cafc14b290758b741bc19f95" => :high_sierra
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

  plist_options startup: true

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
