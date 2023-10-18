class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "https://thekelleys.org.uk/dnsmasq/doc.html"
  url "https://thekelleys.org.uk/dnsmasq/dnsmasq-2.89.tar.gz"
  sha256 "8651373d000cae23776256e83dcaa6723dee72c06a39362700344e0c12c4e7e4"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://thekelleys.org.uk/dnsmasq/"
    regex(/href=.*?dnsmasq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "cac6ed802f57c2b5564b0e74a86c3dd3dba2cfc0872a6338f94e6d7ea896b85e"
    sha256 arm64_ventura:  "490265bd8d3e8392380fff3b0fbb4caf65f918366b5cf8c613372d21844860aa"
    sha256 arm64_monterey: "550f2bc4e841dff11350365deccd14a2ae3977b4a21b499ef25da1658c9aaa9f"
    sha256 arm64_big_sur:  "6c07ed0ee4e4da7f96b3019a99314db35594950a7e74e00268a1d9653c5f3d63"
    sha256 sonoma:         "37c231e1034adfe524fd59764ece9fc6cda5852be288485c4c02ac3380168e11"
    sha256 ventura:        "1c6667316c0c59f169539b20268526dbd809f1e1d4ff1ff4152230745c958213"
    sha256 monterey:       "8d208dd2b6b2571b6fe00abc4cea2e3da949ec722c587a7a373c88e6ea385108"
    sha256 big_sur:        "1790d62200547a99955d7b0cb8925b13343e3b3fd15ee551ebb4d1b1772088df"
    sha256 x86_64_linux:   "402f77fca452d49f05c63d63bb83dc01cd70e005b4d4f5094706d5b64201560f"
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
