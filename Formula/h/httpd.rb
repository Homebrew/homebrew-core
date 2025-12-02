class Httpd < Formula
  desc "Apache HTTP server"
  homepage "https://httpd.apache.org/"
  url "https://dlcdn.apache.org/httpd/httpd-2.4.65.tar.bz2"
  mirror "https://downloads.apache.org/httpd/httpd-2.4.65.tar.bz2"
  sha256 "58b8be97d9940ec17f7656c0c6b9f41b618aac468b894b534148e3296c53b8b3"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "6c1e678fc64a7be25d19e7e907c43d156abc2d3b0b26988d4d8dfc3951b60091"
    sha256 arm64_sequoia: "2d93960ea5559bbe3e28b0e17f392a0ecedcda6e5fa1942a0cbec66995d7d72e"
    sha256 arm64_sonoma:  "ba2ab3317d9c73b42bd3b9bf06167e5ffc75a8148fbf4d5cc6985d353a8c2d5f"
    sha256 sonoma:        "38deefb2d3474adf708f195f2685d9de033e454c5629c158dfe88cde3b9ca44b"
    sha256 arm64_linux:   "8bc54783c18c61100a1603b3a745a747fee5b5f9323a2315ee2d1ef30313c2a3"
    sha256 x86_64_linux:  "554b0bb3a1d8aa0bb67cf7d75b7f6ac86460b8c47fdfedb83e7e9310d5277710"
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "brotli"
  depends_on "libnghttp2"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # fixup prefix references in favour of opt_prefix references
    inreplace "Makefile.in",
      '#@@ServerRoot@@#$(prefix)#', "\#@@ServerRoot@@##{opt_prefix}#"
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

    if OS.mac?
      libxml2 = "#{MacOS.sdk_for_formula(self).path}/usr"
      zlib = "#{MacOS.sdk_for_formula(self).path}/usr"
    else
      libxml2 = Formula["libxml2"].opt_prefix
      zlib = Formula["zlib"].opt_prefix
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
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
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

  service do
    run [opt_bin/"httpd", "-D", "FOREGROUND"]
    environment_variables PATH: std_service_path_env
    run_type :immediate
  end

  test do
    # Ensure modules depending on zlib and xml2 have been compiled
    assert_path_exists lib/"httpd/modules/mod_deflate.so"
    assert_path_exists lib/"httpd/modules/mod_proxy_html.so"
    assert_path_exists lib/"httpd/modules/mod_xml2enc.so"

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

      pid = spawn bin/"httpd", "-X", "-f", "#{testpath}/httpd.conf"

      sleep 3
      sleep 2 if OS.mac? && Hardware::CPU.intel?

      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")

      # Check that `apxs` can find `apu-1-config`.
      system bin/"apxs", "-q", "APU_CONFIG"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
