class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "https://thekelleys.org.uk/dnsmasq/doc.html"
  url "https://thekelleys.org.uk/dnsmasq/dnsmasq-2.90.tar.gz"
  sha256 "8f6666b542403b5ee7ccce66ea73a4a51cf19dd49392aaccd37231a2c51b303b"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://thekelleys.org.uk/dnsmasq/"
    regex(/href=.*?dnsmasq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "74e9c9906acf3ae44bf1c019d7ea85a08673a50bb817b2936fe93ef60e3ea0df"
    sha256 arm64_sonoma:   "b6897c95d454b3d7a0d488b3cba0f525a90c951d8690929a80794aee05f48ae7"
    sha256 arm64_ventura:  "96d78b8341adb55a2f3260fa4813102e7c08bc0d61306401de5bf4f1e49843b2"
    sha256 arm64_monterey: "740412d9203cd865d9cafb9c10a3bc69ef19e44291954d7c26e48b17fd378039"
    sha256 sonoma:         "0e20ef773a39be121ee8fddc46a6dca9f1d6b9c09cc069bfa75334bff479079b"
    sha256 ventura:        "f0fda257b89641375e5711c1afdc66c35771234a7fc2a51c124cc856085dd005"
    sha256 monterey:       "51b10e0af794890ffcf3220848032c3086af3d3f5d488b454003fcde72793225"
    sha256 x86_64_linux:   "ba407d18d57b06e39f5576cda5f97703b1def62c14960d62f16eecd236180fc4"
  end

  depends_on "pkg-config" => :build

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
