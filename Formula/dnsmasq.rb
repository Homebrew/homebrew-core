class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "https://thekelleys.org.uk/dnsmasq/doc.html"
  url "https://thekelleys.org.uk/dnsmasq/dnsmasq-2.88.tar.gz"
  sha256 "da9d26aa3f3fc15f3b58b94edbb9ddf744cbce487194ea480bd8e7381b3ca028"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://thekelleys.org.uk/dnsmasq/"
    regex(/href=.*?dnsmasq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "445f0ae7150242555375d80357bfaf5f137fa7d2f11a520b4e4d84d5b4779562"
    sha256 arm64_monterey: "9feae502fc82390061c40c4ccfdaf25e10a45a41b98a85a7ecb7c15e62ef36a9"
    sha256 arm64_big_sur:  "dbf19b84941dc8bfa09c5d4458b0fe40c141521017825fdd7463860c48c7840d"
    sha256 ventura:        "0435be15ad27677b95d6964f8ecebe75ad037cef7f5d5c94625994b1bec9a382"
    sha256 monterey:       "3beeb1bd136ee4e3d9e50e516cde1ee8c487d9401a53d33a5f6702bc743cb22f"
    sha256 big_sur:        "9a2a10424ea43e08bfa672f3dc4f91b55e724e5a760540e4d23e60ac02590901"
    sha256 x86_64_linux:   "93b869ed076e1861091aa24afdb461c0ff5c25192128068cabb9e4e963f02330"
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

  service do
    run [opt_sbin/"dnsmasq", "--keep-in-foreground", "-C", etc/"dnsmasq.conf", "-7", etc/"dnsmasq.d,*.conf"]
    keep_alive true
    require_root true
  end

  test do
    system "#{sbin}/dnsmasq", "--test"
  end
end
