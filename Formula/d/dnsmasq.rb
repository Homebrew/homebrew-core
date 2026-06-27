class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "https://thekelleys.org.uk/dnsmasq/doc.html"
  url "https://thekelleys.org.uk/dnsmasq/dnsmasq-2.93.tar.gz"
  sha256 "cc967771abdafeb43d10db18932d6b59fd4bed2c69c22acf8cb96aff6920d55f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  compatibility_version 1

  livecheck do
    url "https://thekelleys.org.uk/dnsmasq/"
    regex(/href=.*?dnsmasq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "936e819cb25b03d11a4c25a62aba45a577eea309d86bde77c95a397de862d45f"
    sha256 arm64_sequoia: "e64cf295c597ad396d43ad626758e842259df423ff4040e718a7ad2aede7f1f1"
    sha256 arm64_sonoma:  "b122127a42f82171b2c8b6acfbcba3be39e30462a6cd26dc52d2960f4898c54f"
    sha256 sonoma:        "44c9bc8d12db493851948ae9aa21d37d58d7c5df64515fd98f5e2ad6c4918e1e"
    sha256 arm64_linux:   "ddc2afed0b5be200816bc2241af23d5d604ebe24731d6f5895a158a59363d582"
    sha256 x86_64_linux:  "9531eadacd6f3e42d0c2c99a4d66e5669ec96f56d228b83d7072574daf394812"
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

  def caveats
    <<~EOS
      On current macOS releases, `/etc/resolver/<domain>` resolver overrides do not work if the nameserver is `127.0.0.1` and dnsmasq is running on a non-53 port.
      To use scoped resolver zones reliably, bind dnsmasq to a non-localhost IP (e.g., a loopback alias like 10.0.0.1) on port 53.
    EOS
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
