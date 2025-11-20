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
    rebuild 1
    sha256 arm64_tahoe:   "cb56fd74e35d80af1e89152f461cfa9f77a4ec33a6dac3b33f06a00feeef77c7"
    sha256 arm64_sequoia: "33f6b71563014d09360d028e613be61c7ed75e74360396efc4d3b9ce8899965e"
    sha256 arm64_sonoma:  "b13b42d80e6be073357328442e047f4f7bad2646b03f799dca4b848a5a3d150b"
    sha256 sonoma:        "4b2d8e61a8bb3601df2439914950fad6407edeae7db487dcfe6fd83987988cc9"
    sha256 arm64_linux:   "6eb516dbfd16d9dd493604334be39927e6165c0f06fe631115aa3b40cd4185a5"
    sha256 x86_64_linux:  "720d6acd1910592e9c17928a15433e0f2eabea814cf6e3e653f04be5d35d8d8b"
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
    system sbin/"dnsmasq", "--test"
  end
end
