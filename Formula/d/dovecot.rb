class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.4/dovecot-2.4.0.tar.gz"
  sha256 "e90e49f8c31b09a508249a4fee8605faa65fe320819bfcadaf2524126253d5ae"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https://repo.dovecot.org/"
    regex(/href=.*?ce[._-]v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "51fe5736c4fe74c858e7cc2901b62c18f471004a5bc28574104bd3cc62491df3"
    sha256 arm64_sequoia: "09ffefff96a42aeb4368075229fcd8439842729c3275211dc45bfb810e0fd046"
    sha256 arm64_sonoma:  "fb47228aa002ca7a17b580475f202229ff05021438af7f0b8c28bf943a003ee1"
    sha256 arm64_ventura: "7c02197a94945e427d5edfec3f1647a981a96d707cd2f59f122de8eb0e777476"
    sha256 sonoma:        "e007ae6fa96aec1e7b6f89b4c4ed1455dd3f0397b59b5aae6f7c3cbd2a4ff64f"
    sha256 ventura:       "d062efc159a5752d977a820107b8c4f11dc766489e06bff2860f91832f877a0b"
    sha256 arm64_linux:   "9cfb86bef709c2e6a6f1e4dac4feac680d902718e20f5ee8fff2f9b28aa838bd"
    sha256 x86_64_linux:  "d352c07b0869e303d279ef574e9b5d595f714b50cbb08d9f10eefe4dc3f07f37"
  end

  depends_on "pkgconf" => :build
  depends_on "openldap"
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtirpc"
    depends_on "linux-pam"
    depends_on "lz4"
    depends_on "xz"
    depends_on "zstd"
  end

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.4/dovecot-pigeonhole-2.4.0.tar.gz"
    sha256 "0ed08ae163ac39a9447200fbb42d7b3b05d35e91d99818dd0f4afd7ad1dbc753"
  end

  # `uoff_t` and `plugins/var-expand-crypt` patches, upstream pr ref, https://github.com/dovecot/core/pull/232
  patch do
    url "https://github.com/dovecot/core/commit/bbfab4976afdf38a7fa966752de33481f9d2c2e5.patch?full_index=1"
    sha256 "f5a77eeaf5978b75a6c7d1d9d4b7623679aec047c3dae63516105774ae6c04de"
  end
  patch :DATA

  def install
    # Re-generate file as only Linux has inotify support for imap-hibernate
    rm "src/config/all-settings.c" unless OS.linux?

    args = %W[
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-ldap
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

    cp_r share/"doc/dovecot/example-config", testpath/"example"
    (testpath/"example/dovecot.conf").write <<~EOS
      # required in 2.4
      dovecot_config_version = 2.4.0
      dovecot_storage_version = 2.4.0

      base_dir = #{testpath}
      listen = *
      ssl = no

      default_login_user = #{ENV["USER"]}
      default_internal_user = #{ENV["USER"]}

      # reference other conf files
      # !include conf.d/*.conf

      # same as 2.3
      log_path = syslog
      auth_mechanisms = plain
    EOS

    system bin/"doveconf", "-c", testpath/"example/dovecot.conf"
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
