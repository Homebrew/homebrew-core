class Httpd < Formula
  desc "Apache HTTP server"
  homepage "https://httpd.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=httpd/httpd-2.4.67.tar.bz2"
  mirror "https://downloads.apache.org/httpd/httpd-2.4.67.tar.bz2"
  sha256 "66cd206637b0d5c446fa7dabe75fe03525da8fb55855876c46288cd88b136aa4"
  license "Apache-2.0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "92c7fc0295bfbdfa5fafd74e2238bc085e88323cb4d2403f80e3923bbcb6e3c1"
    sha256 arm64_sequoia: "c8da02853aee3dcb3df3f605ee6fb9fc79fabe74cd3e4e26a4fe6059d56ea9f5"
    sha256 arm64_sonoma:  "cb9ec186e14e4638a2f4aeead3a1982fb261c616d274a68ca4852698d770731e"
    sha256 sonoma:        "d6c4ebe501eef6d1689d7657334a02a94b2d5c328703f6843cf439d9c7ca743b"
    sha256 arm64_linux:   "87ac386e2e874488028c6f0a14966a7b862009423f9f57f3c0d4e0bd88d002ad"
    sha256 x86_64_linux:  "e8d640acc050b16b2804d893f1e60888f753b661488613bf86ecf36f81351845"
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "brotli"
  depends_on "libnghttp2"
  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # OpenSSL 4 makes ASN.1 string types opaque.
  patch :DATA

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
      zlib = Formula["zlib-ng-compat"].opt_prefix
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
                          "--with-ssl=#{Formula["openssl@4"].opt_prefix}",
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

      pid = spawn bin/"httpd", "-X", "-f", testpath/"httpd.conf"

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

__END__
diff --git a/modules/ssl/ssl_engine_vars.c b/modules/ssl/ssl_engine_vars.c
index e894222..87798f8 100644
--- a/modules/ssl/ssl_engine_vars.c
+++ b/modules/ssl/ssl_engine_vars.c
@@ -693,23 +693,28 @@ static char *ssl_var_lookup_ssl_cert_remain(apr_pool_t *p, ASN1_TIME *tm)
     apr_time_exp_t exp = {0};
     long diff;
-    unsigned char *dp;
+    const unsigned char *dp, *tm_data;
+    int tm_length, tm_type;
 
     /* Fail if the time isn't a valid ASN.1 TIME; RFC3280 mandates
      * that the seconds digits are present even though ASN.1
      * doesn't. */
-    if ((tm->type == V_ASN1_UTCTIME && tm->length < 11) ||
-        (tm->type == V_ASN1_GENERALIZEDTIME && tm->length < 13) ||
+    tm_data = ASN1_STRING_get0_data(tm);
+    tm_length = ASN1_STRING_length(tm);
+    tm_type = ASN1_STRING_type(tm);
+    if (!tm_data ||
+        (tm_type == V_ASN1_UTCTIME && tm_length < 11) ||
+        (tm_type == V_ASN1_GENERALIZEDTIME && tm_length < 13) ||
         !ASN1_TIME_check(tm)) {
         return apr_pstrdup(p, "0");
     }
 
-    if (tm->type == V_ASN1_UTCTIME) {
-        exp.tm_year = DIGIT2NUM(tm->data);
+    if (tm_type == V_ASN1_UTCTIME) {
+        exp.tm_year = DIGIT2NUM(tm_data);
         if (exp.tm_year <= 50) exp.tm_year += 100;
-        dp = tm->data + 2;
+        dp = tm_data + 2;
     } else {
-        exp.tm_year = DIGIT2NUM(tm->data) * 100 + DIGIT2NUM(tm->data + 2) - 1900;
-        dp = tm->data + 4;
+        exp.tm_year = DIGIT2NUM(tm_data) * 100 + DIGIT2NUM(tm_data + 2) - 1900;
+        dp = tm_data + 4;
     }
 
     exp.tm_mon = DIGIT2NUM(dp) - 1;
@@ -1030,11 +1035,11 @@ static int dump_extn_value(BIO *bio, ASN1_OCTET_STRING *str)
 {
-    const unsigned char *pp = str->data;
+    const unsigned char *pp = ASN1_STRING_get0_data(str);
     ASN1_STRING *ret = ASN1_STRING_new();
     int rv = 0;
 
     /* This allows UTF8String, IA5String, VisibleString, or BMPString;
      * conversion to UTF-8 is forced. */
-    if (d2i_DISPLAYTEXT(&ret, &pp, str->length)) {
+    if (pp && d2i_DISPLAYTEXT(&ret, &pp, ASN1_STRING_length(str))) {
         ASN1_STRING_print_ex(bio, ret, ASN1_STRFLGS_UTF8_CONVERT);
         rv = 1;
     }
diff --git a/modules/ssl/ssl_engine_ocsp.c b/modules/ssl/ssl_engine_ocsp.c
--- a/modules/ssl/ssl_engine_ocsp.c
+++ b/modules/ssl/ssl_engine_ocsp.c
@@ -39,7 +39,7 @@ const char *modssl_get_ocsp_responder_from_cert(apr_pool_t *pool, X509 *cert)
             && value->location->type == GEN_URI) {
             result = apr_pstrdup(pool,
-                                 (char *)value->location->d.uniformResourceIdentifier->data);
+                                 (char *)ASN1_STRING_get0_data(value->location->d.uniformResourceIdentifier));
         }
     }
 
