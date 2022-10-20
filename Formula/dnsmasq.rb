class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "https://thekelleys.org.uk/dnsmasq/doc.html"
  url "https://thekelleys.org.uk/dnsmasq/dnsmasq-2.87.tar.gz"
  sha256 "ae39bffde9c37e4d64849b528afeb060be6bad6d1044a3bd94a49fce41357284"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://thekelleys.org.uk/dnsmasq/"
    regex(/href=.*?dnsmasq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "357a30adc744526d520802f38099e0759116b822994e29848a6f3d24926ff467"
    sha256 arm64_big_sur:  "7e5ed2bd70f5894c99baaf8de7b4ca3130beae2fd8293bb70455f0c2d3168150"
    sha256 monterey:       "fc001641289ee8238714157e67feea1494f56578378e37823699dfa2cdcaf346"
    sha256 big_sur:        "8cd8b71e6d7d63d2510ac8a37a98ca6e9ae8989a58d50f9e40a53660a975e600"
    sha256 catalina:       "2ea93b8e8ad857aca2846a4d4f66c3dae1e119712b5608d0ba6919cf9df63eca"
    sha256 x86_64_linux:   "a3e8cb542671c0536c50680039742292c26d80a0aaa399c4860073bb6b7f5f05"
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

  service do
    run [opt_sbin/"dnsmasq", "--keep-in-foreground", "-C", etc/"dnsmasq.conf", "-7", etc/"dnsmasq.d,*.conf"]
    keep_alive true
  end

  test do
    system "#{sbin}/dnsmasq", "--test"
  end
end
