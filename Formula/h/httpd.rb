class Httpd < Formula
  desc "Apache HTTP server"
  homepage "https://httpd.apache.org/"
  url "https://dlcdn.apache.org/httpd/httpd-2.4.59.tar.bz2"
  mirror "https://downloads.apache.org/httpd/httpd-2.4.59.tar.bz2"
  sha256 "ec51501ec480284ff52f637258135d333230a7d229c3afa6f6c2f9040e321323"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "e8e72b4403ec512b5bc7c0f717750a273889f96c5456e21ea9ed03f74417eec7"
    sha256 arm64_ventura:  "657b43add12664424e3f88bfe7ad6e73e8807dae18c02660c082b52fdbb34627"
    sha256 arm64_monterey: "950499fb2aa635e9675d078e5de3bfcd89e3fc18c9e1ba406f2b119bdd5623e2"
    sha256 sonoma:         "d32832d750e4f2661e404ecbabc9a1627bdf0df4e8eaef81b69121b82c1652ea"
    sha256 ventura:        "fbfd8a64065689eee68d8f9bd91c3e8e5fd1eefc37635136e315d0de6703b4d2"
    sha256 monterey:       "b412e5f023f374ea40fea43650c41dab51cbcf8ccb45b026817e76e77afb163d"
    sha256 x86_64_linux:   "e93778dca46fee41292c4be4cbac14a0497218d0588a1ee4d06028e7ba4222b7"
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "brotli"
  depends_on "libnghttp2"
  depends_on "openssl@3"
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

    if OS.mac?
      libxml2 = "#{MacOS.sdk_path_if_needed}/usr"
      zlib = "#{MacOS.sdk_path_if_needed}/usr"
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
