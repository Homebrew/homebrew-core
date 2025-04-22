class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "https://thekelleys.org.uk/dnsmasq/doc.html"
  url "https://thekelleys.org.uk/dnsmasq/dnsmasq-2.91.tar.gz"
  sha256 "2d26a048df452b3cfa7ba05efbbcdb19b12fe7a0388761eb5d00938624bd76c8"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://thekelleys.org.uk/dnsmasq/"
    regex(/href=.*?dnsmasq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "482fb9095287d8a57943049c8eea8ea59f2c9f127b23e5c9820bcc79f514a0b9"
    sha256 arm64_sonoma:  "0a155cd6f1100c05013a1522ef2cd49170d38cc17bbc8e6efe094a15d02a2dd8"
    sha256 arm64_ventura: "cdab8f9171fdfdb0d3992f985bfa47f1e37a21ea8852b858dc99d3530fcdd90f"
    sha256 sonoma:        "4aa45af1edb9037c600a7dfac19d606adf9ff99751868a21c69dfc3fbbd2aa3d"
    sha256 ventura:       "00b9f8f1fa62a1e802697213e4f4a8efde894984a686246eca65d94184e7bfe4"
    sha256 arm64_linux:   "d8dc8fbdd6b69cd8ecf6718792c5121065b4bf7cb06edc107a0de8683c92fc74"
    sha256 x86_64_linux:  "c7ccd503b66d1e2096490ff52a0fb277fbc91ff7aa57c313fb1b3fdf531560ee"
  end

  depends_on "pkgconf" => :build

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace %w[dnsmasq.conf.example src/config.h man/dnsmasq.8
                 man/es/dnsmasq.8 man/fr/dnsmasq.8].each do |s|
      s.gsub! "/var/lib/misc/dnsmasq.leases",
              var/"lib/misc/dnsmasq/dnsmasq.leases", audit_result: false
      s.gsub! "/etc/dnsmasq.conf", etc/"dnsmasq.conf", audit_result: false
      s.gsub! "/var/run/dnsmasq.pid", var/"run/dnsmasq/dnsmasq.pid", audit_result: false
      s.gsub! "/etc/dnsmasq.d", etc/"dnsmasq.d", audit_result: false
      s.gsub! "/etc/ppp/resolv.conf", etc/"dnsmasq.d/ppp/resolv.conf", audit_result: false
      s.gsub! "/etc/dhcpc/resolv.conf", etc/"dnsmasq.d/dhcpc/resolv.conf", audit_result: false
      s.gsub! "/usr/sbin/dnsmasq", HOMEBREW_PREFIX/"sbin/dnsmasq", audit_result: false
    end

    # Fix compilation on newer macOS versions.
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542"

    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags || ""
      s.change_make_var! "LDFLAGS", ENV.ldflags || ""
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

  service do
    run [opt_sbin/"dnsmasq", "--keep-in-foreground", "-C", etc/"dnsmasq.conf", "-7", etc/"dnsmasq.d,*.conf"]
    keep_alive true
    require_root true
  end

  test do
    system "#{sbin}/dnsmasq", "--test"
  end
end
