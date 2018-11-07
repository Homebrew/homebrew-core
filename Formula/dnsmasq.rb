class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "http://www.thekelleys.org.uk/dnsmasq/doc.html"
  url "http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.80.tar.gz"
  sha256 "9e4a58f816ce0033ce383c549b7d4058ad9b823968d352d2b76614f83ea39adc"

  bottle do
    sha256 "1cdcb702a0dbfd1b22daac69f4e52953ffbae60292211a3df61e3b904838aa3d" => :mojave
    sha256 "d151f9072dd7e594caf4852107a4361e52d895ab2038308c83af53c37ded6608" => :high_sierra
    sha256 "c5aedeadca97702f5c0e4beb335f4e3f93de4ef6e3522fbd2399bc084cc78512" => :sierra
  end

  option "with-libidn", "Compile with IDN support"
  option "with-dnssec", "Compile with DNSSEC support"

  deprecated_option "with-idn" => "with-libidn"

  depends_on "pkg-config" => :build
  depends_on "nettle" if build.with? "dnssec"
  depends_on "libidn" => :optional
  depends_on "gettext" if build.with? "libidn"

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

    # Optional IDN support
    if build.with? "libidn"
      inreplace "src/config.h", "/* #define HAVE_IDN */", "#define HAVE_IDN"
      ENV.append_to_cflags "-I#{Formula["gettext"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["gettext"].opt_lib} -lintl"
    end

    # Optional DNSSEC support
    if build.with? "dnssec"
      inreplace "src/config.h", "/* #define HAVE_DNSSEC */", "#define HAVE_DNSSEC"
      inreplace "dnsmasq.conf.example" do |s|
        s.gsub! "#conf-file=%%PREFIX%%/share/dnsmasq/trust-anchors.conf",
                "conf-file=#{opt_pkgshare}/trust-anchors.conf"
        s.gsub! "#dnssec", "dnssec"
      end
    end

    # Fix compilation on Lion
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542" if MacOS.version >= :lion
    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "LDFLAGS", ENV.ldflags
    end

    if build.with? "libidn"
      system "make", "install-i18n", "PREFIX=#{prefix}"
    else
      system "make", "install", "PREFIX=#{prefix}"
    end

    pkgshare.install "trust-anchors.conf" if build.with? "dnssec"
    etc.install "dnsmasq.conf.example" => "dnsmasq.conf"
  end

  def post_install
    (var/"lib/misc/dnsmasq").mkpath
    (var/"run/dnsmasq").mkpath
    (etc/"dnsmasq.d/ppp").mkpath
    (etc/"dnsmasq.d/dhcpc").mkpath
  end

  def caveats; <<~EOS
    To configure dnsmasq, take the default example configuration at
      #{etc}/dnsmasq.conf and edit to taste.
  EOS
  end

  plist_options :startup => true

  def plist; <<~EOS
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
