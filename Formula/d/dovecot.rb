class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.4/dovecot-2.4.5.tar.gz"
  sha256 "868c2686a61b5f8e00a3e4721789b1ab46e6528fd773a5fbed07a6ecba7731e6"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https://dovecot.org/releases/"
    regex(/v?(\d+(?:[._-]\d+)+)/i)
    strategy :page_match do |page, regex|
      major_minor = page.scan(regex)&.flatten&.last
      next if major_minor.blank?

      # Check the page for the newest major/minor version, which links to the
      # latest tarball (containing the full version in the file name)
      version_page = Homebrew::Livecheck::Strategy.page_content(
        URI.join("https://dovecot.org/releases/", major_minor).to_s,
      )
      next if version_page[:content].blank?

      version_page[:content].scan(regex)&.flatten&.last
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "08fa97309c333f866d990ff425c83942ee3b1ae8492f6921358475cd9448a5c3"
    sha256 arm64_tahoe:       "463fa86f7154a7306623d716203e9bd126a30108069800c3aa59fd44cf3b4b38"
    sha256 arm64_sequoia:     "d1b3cc112059eec79e20c376cb835a40109bd0ff105e5463b124ec556e9ad021"
    sha256 arm64_linux:       "0f62414a5f6c0cca8f694780c894049e861d9cddff84093316bdb69d58a91251"
    sha256 x86_64_linux:      "9f4cea03363d421749f158033d7f7648dd9544d0d216292c4e3b3c485218c683"
  end

  depends_on "pkgconf" => :build
  depends_on "lua"
  depends_on "openldap"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "netcat" => :test
  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "libtirpc"
    depends_on "linux-pam"
    depends_on "lz4"
    depends_on "xz"
    depends_on "zlib-ng-compat"
    depends_on "zstd"
  end

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.4/dovecot-pigeonhole-2.4.5.tar.gz"
    sha256 "ad7c478cb3aaa76c5f81f86727a3e6843645b0a1253f5684fb8a0beec0d22925"

    livecheck do
      formula :parent
    end
  end

  # `uoff_t` and `plugins/var-expand-crypt` patches
  patch do
    url "https://github.com/dovecot/core/commit/bbfab4976afdf38a7fa966752de33481f9d2c2e5.patch?full_index=1"
    sha256 "f5a77eeaf5978b75a6c7d1d9d4b7623679aec047c3dae63516105774ae6c04de"
    type :unofficial
    resolves "https://github.com/dovecot/core/pull/232"
  end
  # `plugins/var-expand-crypt` and `lib-storage-lua` missing `lib-var-expand` in LIBADD
  patch :DATA

  # Apply Fedora patch to support Lua 5.5
  patch do
    url "https://src.fedoraproject.org/rpms/dovecot/raw/1b94c9d8fe9f5840e7a8dcd1268960fd4627d419/f/dovecot-2.4.2-lua-5.5.patch"
    sha256 "e43bf7b80f6f5537178966b915c9d87cf80057da3d129148999b9ec7539f70ef"
    type :unofficial
  end

  def install
    # Re-generate file as only Linux has inotify support for imap-hibernate
    rm "src/config/all-settings.c" unless OS.linux?

    ENV.append "LIBS", "-liconv" if OS.mac?

    args = %W[
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-ldap
      --with-lua=yes
      --with-pam
      --with-sqlite
      --without-icu
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    resource("pigeonhole").stage do
      args = %W[
        --with-dovecot=#{lib}/dovecot
        --with-ldap
      ]

      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      For Dovecot to work, you may need to create a dovecot user
      and group depending on your configuration file options.
    EOS
  end

  service do
    run [opt_sbin/"dovecot", "-F"]
    require_root true
    environment_variables PATH: std_service_path_env
    error_log_path var/"log/dovecot/dovecot.log"
    log_path var/"log/dovecot/dovecot.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dovecot --version")

    port = free_port.to_s
    cp_r share/"doc/dovecot/example-config", testpath/"config"
    (testpath/"config/dovecot.conf").write <<~EOS
      dovecot_config_version = #{version}
      dovecot_storage_version = #{version}

      base_dir = #{testpath}/run
      state_dir = #{testpath}/state
      listen = *
      ssl = no
      protocols = imap
      service imap-login {
        inet_listener imap {
          port = #{port}
        }
      }

      default_login_user = #{ENV["USER"]}
      default_internal_user = #{ENV["USER"]}
      default_internal_group = #{Etc.getgrgid(Process.egid).name}
      auth_mechanisms = plain
      log_path = #{testpath}/dovecot.log
    EOS

    system bin/"doveconf", "-c", testpath/"config/dovecot.conf"

    pid = spawn sbin/"dovecot", "-c", testpath/"config/dovecot.conf", "-F"
    begin
      sleep 5
      system "nc", "-z", "localhost", port
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/src/lib-var-expand-crypt/Makefile.in b/src/lib-var-expand-crypt/Makefile.in
index 6c8b1ad..b721ad5 100644
--- a/src/lib-var-expand-crypt/Makefile.in
+++ b/src/lib-var-expand-crypt/Makefile.in
@@ -177,7 +177,11 @@ am__uninstall_files_from_dir = { \
 am__installdirs = "$(DESTDIR)$(moduledir)" \
 	"$(DESTDIR)$(pkginc_libdir)"
 LTLIBRARIES = $(module_LTLIBRARIES)
-var_expand_crypt_la_LIBADD =
+var_expand_crypt_la_LIBADD = \
+  ../lib/liblib.la \
+  ../lib-json/libjson.la \
+  ../lib-dcrypt/libdcrypt.la \
+  ../lib-var-expand/libvar_expand.la
 am_var_expand_crypt_la_OBJECTS = var-expand-crypt.lo
 var_expand_crypt_la_OBJECTS = $(am_var_expand_crypt_la_OBJECTS)
 AM_V_lt = $(am__v_lt_@AM_V@)
diff --git a/src/lib-storage-lua/Makefile.in b/src/lib-storage-lua/Makefile.in
--- a/src/lib-storage-lua/Makefile.in
+++ b/src/lib-storage-lua/Makefile.in
@@ -521,11 +521,14 @@
 
 libdovecot_storage_lua_la_LIBADD = \
 	../lib-dovecot-storage/libdovecot-storage.la \
-	../lib-lua/libdovecot-lua.la
+	../lib-lua/libdovecot-lua.la \
+	$(LIBDOVECOT) \
+	$(LUA_LIBS)
 
 libdovecot_storage_lua_la_DEPENDENCIES = \
 	../lib-dovecot-storage/libdovecot-storage.la \
-	../lib-lua/libdovecot-lua.la
+	../lib-lua/libdovecot-lua.la \
+	$(LIBDOVECOT_DEPS)
 
 libdovecot_storage_lua_la_LDFLAGS = -export-dynamic
 headers = \
diff --git a/src/auth/Makefile.in b/src/auth/Makefile.in
--- a/src/auth/Makefile.in
+++ b/src/auth/Makefile.in
@@ -1119,7 +1119,7 @@
 	$(am__append_8)
 auth_CPPFLAGS = $(AM_CPPFLAGS) $(BINARY_CFLAGS)
 auth_LDADD = $(auth_libs) $(LIBDOVECOT) $(AUTH_LIBS) $(BINARY_LDFLAGS) $(AUTH_LUA_LDADD)
-auth_DEPENDENCIES = $(auth_libs) $(LIBDOVECOT_DEPS)
+auth_DEPENDENCIES = $(filter %.la,$(auth_libs)) $(LIBDOVECOT_DEPS)
 auth_SOURCES = main.c $(auth_common_sources)
 ldap_sources = db-ldap.c db-ldap-sasl.c db-ldap-settings.c passdb-ldap.c userdb-ldap.c
 lua_sources = db-lua.c passdb-lua.c userdb-lua.c
