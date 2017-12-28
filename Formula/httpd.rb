class Httpd < Formula
  desc "Apache HTTP server"
  homepage "https://httpd.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=httpd/httpd-2.4.29.tar.bz2"
  sha256 "777753a5a25568a2a27428b2214980564bc1c38c1abf9ccc7630b639991f7f00"
  revision 1

  bottle do
    sha256 "1e2a9985867f72db8af9f85753bd1fe700a1780a03ad60b88b2df55d75dc78d1" => :high_sierra
    sha256 "72e76b6c6fec4f7726884b112cb87fa7ef24ec0ddb945e1b78c35d013b87253b" => :sierra
    sha256 "6776215fd1c0e937a7464dcd9d3143cc22d917a5381dc28ea6ff6242eba3b2a6" => :el_capitan
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "nghttp2"
  depends_on "openssl"
  depends_on "pcre"

  def install
    # fixup prefix references in favour of opt_prefix references
    inreplace "Makefile.in",
      '#@@ServerRoot@@#$(prefix)#', '#@@ServerRoot@@'"##{opt_prefix}#"
    inreplace "docs/conf/extra/httpd-autoindex.conf.in",
      "@exp_iconsdir@", "#{opt_pkgshare}/icons"
    inreplace "docs/conf/extra/httpd-multilang-errordoc.conf.in",
      "@exp_errordir@", "#{opt_pkgshare}/error"

    # fix default user/group when running as root
    inreplace "docs/conf/httpd.conf.in", /(User|Group) daemon/, "\\1 _www"

    # use Slackware-FHS layout as it's closest to what we want.
    # these values cannot be passed directly to configure, unfortunately.
    inreplace "config.layout" do |s|
      s.gsub! "${datadir}/htdocs", "${datadir}"
      s.gsub! "${htdocsdir}/manual", "#{pkgshare}/manual"
      s.gsub! "${datadir}/error",   "#{pkgshare}/error"
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
                          "--enable-cgi",
                          "--enable-pie",
                          "--enable-suexec",
                          "--with-suexec-bin=#{opt_bin}/suexec",
                          "--with-suexec-caller=_www",
                          "--with-port=8080",
                          "--with-sslport=8443",
                          "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-apr-util=#{Formula["apr-util"].opt_prefix}",
                          "--with-mpm=prefork",
                          "--with-nghttp2=#{Formula["nghttp2"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}"
    system "make", "install"

    # suexec does not install without root
    bin.install "support/suexec"

    # remove non-executable files in bin dir (for brew audit)
    rm bin/"envvars"
    rm bin/"envvars-std"

    # avoid using Cellar paths
    inreplace %W[
      #{include}/httpd/ap_config_layout.h
      #{lib}/httpd/build/config_vars.mk
    ] do |s|
      s.gsub! "#{lib}/httpd/modules", "#{HOMEBREW_PREFIX}/lib/httpd/modules"
    end

    inreplace %W[
      #{bin}/apachectl
      #{bin}/apxs
      #{include}/httpd/ap_config_auto.h
      #{include}/httpd/ap_config_layout.h
      #{lib}/httpd/build/config_vars.mk
      #{lib}/httpd/build/config.nice
    ] do |s|
      s.gsub! prefix, opt_prefix
    end

    inreplace "#{lib}/httpd/build/config_vars.mk" do |s|
      pcre = Formula["pcre"]
      s.gsub! pcre.prefix.realpath, pcre.opt_prefix
      s.gsub! "${prefix}/lib/httpd/modules",
              "#{HOMEBREW_PREFIX}/lib/httpd/modules"
    end
  end

  def caveats
    <<~EOS
      DocumentRoot is #{var}/www.

      The default ports have been set in #{etc}/httpd/httpd.conf to 8080 and in
      #{etc}/httpd/extra/httpd-ssl.conf to 8443 so that httpd can run without sudo.
    EOS
  end

  def post_install
    (var/"cache/httpd").mkpath
    (var/"www").mkpath
  end

  plist_options :manual => "apachectl start"

  def plist; <<~EOS
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
      (testpath/"httpd.conf").write <<~EOS
        Listen 8080
        DocumentRoot "#{testpath}"
        ErrorLog "#{testpath}/httpd-error.log"
        LoadModule authz_core_module #{lib}/httpd/modules/mod_authz_core.so
        LoadModule unixd_module #{lib}/httpd/modules/mod_unixd.so
        LoadModule dir_module #{lib}/httpd/modules/mod_dir.so
        LoadModule mpm_prefork_module #{lib}/httpd/modules/mod_mpm_prefork.so
      EOS

      pid = fork do
        exec bin/"httpd", "-X", "-f", "#{testpath}/httpd.conf"
      end
      sleep 3

      assert_match expected_output, shell_output("curl -s 127.0.0.1:8080")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
