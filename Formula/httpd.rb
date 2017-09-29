class Httpd < Formula
  desc "Apache HTTP server"
  homepage "https://httpd.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=httpd/httpd-2.4.27.tar.bz2"
  sha256 "71fcc128238a690515bd8174d5330a5309161ef314a326ae45c7c15ed139c13a"
  revision 2

  bottle do
    sha256 "3dd99ca5888cb88457445747ac100d57141ae64aec92b8c0253eaa7407be08ad" => :high_sierra
    sha256 "0883431c30467c3a11e98ec490baa4f173eb21a7cc38825e0eefa44420ec8c09" => :sierra
    sha256 "1cc36b165c6e386761c1c24e806f3e54707eb3534f83e3fae1091778f0d01737" => :el_capitan
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "nghttp2"
  depends_on "openssl"
  depends_on "pcre"

  def install
    # use Slackware-FHS layout as it's closest to what we want.
    # these values cannot be passed directly to configure, unfortunately.
    inreplace "config.layout" do |s|
      s.gsub! "${datadir}/cgi-bin", "#{pkgshare}/cgi-bin"
      s.gsub! "${datadir}/error",   "#{pkgshare}/error"
      s.gsub! "${datadir}/htdocs",  "#{pkgshare}/htdocs"
      s.gsub! "${datadir}/icons",   "#{pkgshare}/icons"
    end

    system "./configure", "--enable-layout=Slackware-FHS",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}/httpd",
                          "--datadir=#{var}/www",
                          "--localstatedir=#{var}",
                          "--enable-mpms-shared=all",
                          "--enable-mods-shared=all",
                          "--enable-pie",
                          "--with-port=8080",
                          "--with-sslport=8443",
                          "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-apr-util=#{Formula["apr-util"].opt_prefix}",
                          "--with-nghttp2=#{Formula["nghttp2"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}"
    system "make", "install"

    # remove non-executable files in bin dir (for brew audit)
    rm bin/"envvars"
    rm bin/"envvars-std"

    # avoid using Cellar paths
    inreplace %W[
      #{lib}/httpd/build/config_vars.mk
      #{include}/httpd/ap_config_layout.h
    ] do |s|
      s.gsub! "#{lib}/httpd/modules", "#{HOMEBREW_PREFIX}/lib/httpd/modules"
      s.gsub! prefix, opt_prefix
    end
    inreplace "#{lib}/httpd/build/config_vars.mk" do |s|
      pcre = Formula["pcre"]
      s.gsub! pcre.prefix.realpath, pcre.opt_prefix
      s.gsub! "${prefix}/lib/httpd/modules",
              "#{HOMEBREW_PREFIX}/lib/httpd/modules"
    end
  end

  def post_install
    (var/"cache/httpd").mkpath
    (var/"www").mkpath
  end

  plist_options :manual => "apachectl start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/httpd</string>
        <string>-D</string>
        <string>FOREGROUND</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    begin
      expected_output = "Hello world!"
      (testpath/"index.html").write expected_output
      (testpath/"httpd.conf").write <<-EOS.undent
        Listen 8080
        DocumentRoot "#{testpath}"
        ErrorLog "#{testpath}/httpd-error.log"
        LoadModule authz_core_module #{lib}/httpd/modules/mod_authz_core.so
        LoadModule unixd_module #{lib}/httpd/modules/mod_unixd.so
        LoadModule dir_module #{lib}/httpd/modules/mod_dir.so
        LoadModule mpm_event_module #{lib}/httpd/modules/mod_mpm_event.so
      EOS

      pid = fork do
        exec bin/"httpd", "-DFOREGROUND", "-f", "#{testpath}/httpd.conf"
      end
      sleep 3

      assert_match expected_output, shell_output("curl 127.0.0.1:8080")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
