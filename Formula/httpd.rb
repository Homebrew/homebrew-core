class Httpd < Formula
  desc "Apache HTTP server"
  homepage "https://httpd.apache.org/"
  url "https://dlcdn.apache.org/httpd/httpd-2.4.54.tar.bz2"
  mirror "https://downloads.apache.org/httpd/httpd-2.4.54.tar.bz2"
  sha256 "eb397feeefccaf254f8d45de3768d9d68e8e73851c49afd5b7176d1ecf80c340"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_monterey: "3f62a259d006b6edb185630e69dc388a29445a409b50f737ab1f4a01df47445a"
    sha256 arm64_big_sur:  "d837cd002696e9215283031669a63bcbbfe018c2a94fdf13946198779975159b"
    sha256 monterey:       "c02ce41fea0925e48986f3997d447c5aab462b1fa9bf74a5d0ebe3234b95cd85"
    sha256 big_sur:        "b6398e308e34eb5e1883ab39880c7fb7de6147dc04ad3467ac9c864b43f5d700"
    sha256 catalina:       "f477b0030a9b897bbb638007c458c1d2971964b9ac49248f145ea1231fbcb30f"
    sha256 x86_64_linux:   "7d502362fe3f134b10d4994a604d97d33f14925ad75e8f420ca104fff13c288c"
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "brotli"
  depends_on "libnghttp2"
  depends_on "openssl@1.1"
  depends_on "pcre2"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

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

    libxml2 = "#{MacOS.sdk_path_if_needed}/usr"
    libxml2 = Formula["libxml2"].opt_prefix if OS.linux?
    zlib = if OS.mac?
      "#{MacOS.sdk_path_if_needed}/usr"
    else
      Formula["zlib"].opt_prefix
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
                          "--enable-authnz-fcgi",
                          "--enable-cgi",
                          "--enable-pie",
                          "--enable-suexec",
                          "--with-suexec-bin=#{opt_bin}/suexec",
                          "--with-suexec-caller=_www",
                          "--with-port=8080",
                          "--with-sslport=8443",
                          "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-apr-util=#{Formula["apr-util"].opt_prefix}",
                          "--with-brotli=#{Formula["brotli"].opt_prefix}",
                          "--with-libxml2=#{libxml2}",
                          "--with-mpm=prefork",
                          "--with-nghttp2=#{Formula["libnghttp2"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-pcre=#{Formula["pcre2"].opt_prefix}/bin/pcre2-config",
                          "--with-z=#{zlib}",
                          "--disable-lua",
                          "--disable-luajit"
    system "make"
    ENV.deparallelize if OS.linux?
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
      s.gsub! lib/"httpd/modules", HOMEBREW_PREFIX/"lib/httpd/modules"
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
      pcre = Formula["pcre2"]
      s.gsub! pcre.prefix.realpath, pcre.opt_prefix
      s.gsub! "${prefix}/lib/httpd/modules", HOMEBREW_PREFIX/"lib/httpd/modules"
      s.gsub! Superenv.shims_path, HOMEBREW_PREFIX/"bin"
    end
  end

  def post_install
    (var/"cache/httpd").mkpath
    (var/"www").mkpath
  end

  def caveats
    <<~EOS
      DocumentRoot is #{var}/www.

      The default ports have been set in #{etc}/httpd/httpd.conf to 8080 and in
      #{etc}/httpd/extra/httpd-ssl.conf to 8443 so that httpd can run without sudo.
    EOS
  end

  plist_options manual: "apachectl start"

  service do
    run [opt_bin/"httpd", "-D", "FOREGROUND"]
    environment_variables PATH: std_service_path_env
    run_type :immediate
  end

  test do
    # Ensure modules depending on zlib and xml2 have been compiled
    assert_predicate lib/"httpd/modules/mod_deflate.so", :exist?
    assert_predicate lib/"httpd/modules/mod_proxy_html.so", :exist?
    assert_predicate lib/"httpd/modules/mod_xml2enc.so", :exist?

    begin
      port = free_port

      expected_output = "Hello world!"
      (testpath/"index.html").write expected_output
      (testpath/"httpd.conf").write <<~EOS
        Listen #{port}
        ServerName localhost:#{port}
        DocumentRoot "#{testpath}"
        ErrorLog "#{testpath}/httpd-error.log"
        PidFile "#{testpath}/httpd.pid"
        LoadModule authz_core_module #{lib}/httpd/modules/mod_authz_core.so
        LoadModule unixd_module #{lib}/httpd/modules/mod_unixd.so
        LoadModule dir_module #{lib}/httpd/modules/mod_dir.so
        LoadModule mpm_prefork_module #{lib}/httpd/modules/mod_mpm_prefork.so
      EOS

      pid = fork do
        exec bin/"httpd", "-X", "-f", "#{testpath}/httpd.conf"
      end
      sleep 3

      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")

      # Check that `apxs` can find `apu-1-config`.
      system bin/"apxs", "-q", "APU_CONFIG"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
