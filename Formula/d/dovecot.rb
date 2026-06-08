class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.4/dovecot-2.4.3.tar.gz"
  sha256 "e0b30330fe51e47ecfcf641bc16041184d91bdd0ac3db789b7cef54e3a75ac9b"
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
    sha256 arm64_tahoe:   "33d00f9e5aa9aa95297325dac2ad87c6551e5c703e1f0799524d10ad4ea1a2c7"
    sha256 arm64_sequoia: "4c9f732d67423229e91d66d09a23db271a177487ef48c9e2bb4f063a84604e1e"
    sha256 arm64_sonoma:  "5f5065b7ea5eca7665268d801f4eb95b0278d7aab53aabbce0882a86319d8280"
    sha256 sonoma:        "f32f1eeedcfc044bd5993b879cccec41acbb2b41edbccba8bd781d9bcc23c4ae"
    sha256 arm64_linux:   "b775760a632ba0794ab7bd5f0e65d1b06dd00e25278b348461c1f00d4803bea0"
    sha256 x86_64_linux:  "5c4c4725815b329a0aef8bca76ba442bef55b57602eb021d4aa0adb15b66b97f"
  end

  depends_on "pkgconf" => :build
  depends_on "lua@5.4"
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
    url "https://pigeonhole.dovecot.org/releases/2.4/dovecot-pigeonhole-2.4.3.tar.gz"
    sha256 "219c472a5fa3e6f7a6cb76ff5118bcbead73e14cd4157d3701425245756cb5f8"

    livecheck do
      formula :parent
    end
  end

  # `uoff_t` and `plugins/var-expand-crypt` patches, upstream pr ref, https://github.com/dovecot/core/pull/232
  patch do
    url "https://github.com/dovecot/core/commit/bbfab4976afdf38a7fa966752de33481f9d2c2e5.patch?full_index=1"
    sha256 "f5a77eeaf5978b75a6c7d1d9d4b7623679aec047c3dae63516105774ae6c04de"
  end
  # `plugins/var-expand-crypt` and `lib-storage-lua` missing `lib-var-expand` in LIBADD
  patch :DATA

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
