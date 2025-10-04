class PostgresqlAT15 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v15.14/postgresql-15.14.tar.bz2"
  sha256 "06dd75d305cd3870ee62b3932e661c624543eaf9ae2ba37cdec0a4f8edd051d2"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(15(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "f5e1607af0e0a31e28eaa4465dccdb83cf548d0a61437dbdf67619ce9f5b72a0"
    sha256 arm64_sequoia: "f3dcce97af544e535fbc7427ddda57a35a01c15451e892d382e76b27c03fc784"
    sha256 arm64_sonoma:  "42b6e60b01971c13c8493371afa72180988156ce2cf5869038c619424d5837b1"
    sha256 arm64_ventura: "da02b1aa70bc27707385596d4a1c282f05bb5e7d61df1c43a9f5b001e0f2ae55"
    sha256 sonoma:        "e7121f3ef609e9563d5b9bccbd6cd04bb915ee369e119ac228228dc7b760f46c"
    sha256 ventura:       "fb28e3f132cdd43d1133a6008fd6d9b6b7b962bc8275d5ce1637bd272fe40aef"
    sha256 arm64_linux:   "6daebb526118fbfa8f6b8a2524c0b4b2e639566d2067e17f48b83f2151e270ae"
    sha256 x86_64_linux:  "53dd03e6dd41d7947d82c36a10da2b8d04b2a5e3d79c10e39e3a6bacdad2205a"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2027-11-11", because: :unsupported

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.delete "PKG_CONFIG_LIBDIR"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    # Fix 'libintl.h' file not found for extensions
    if OS.mac?
      ENV.prepend "LDFLAGS", "-L#{Formula["gettext"].opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["gettext"].opt_include}"
    end

    args = std_configure_args + %W[
      --datadir=#{opt_pkgshare}
      --libdir=#{opt_lib}
      --includedir=#{opt_include}
      --sysconfdir=#{etc}
      --docdir=#{doc}
      --enable-nls
      --enable-thread-safety
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-lz4
      --with-zstd
      --with-openssl
      --with-pam
      --with-perl
      --with-uuid=e2fs
      --with-extra-version=\ (#{tap.user})
    ]
    args += %w[--with-bonjour --with-tcl] if OS.mac?

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac? && MacOS.sdk_root_needed?

    system "./configure", *args

    # Work around busted path magic in Makefile.global.in. This can't be specified
    # in ./configure, but needs to be set here otherwise install prefixes containing
    # the string "postgres" will get an incorrect pkglibdir.
    # See https://github.com/Homebrew/homebrew-core/issues/62930#issuecomment-709411789
    system "make", "pkglibdir=#{opt_lib}/postgresql",
                   "pkgincludedir=#{opt_include}/postgresql",
                   "includedir_server=#{opt_include}/postgresql/server"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}/postgresql",
                                    "includedir=#{include}",
                                    "pkgincludedir=#{include}/postgresql",
                                    "includedir_server=#{include}/postgresql/server",
                                    "includedir_internal=#{include}/postgresql/internal"
    return unless OS.linux?

    inreplace lib/"postgresql/pgxs/src/Makefile.global",
              "LD = #{Superenv.shims_path}/ld",
              "LD = #{HOMEBREW_PREFIX}/bin/ld"
  end

  def post_install
    (var/"log").mkpath
    postgresql_datadir.mkpath

    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"initdb", "--locale=en_US.UTF-8", "-E", "UTF-8", postgresql_datadir unless pg_version_exists?
  end

  def postgresql_datadir
    var/name
  end

  def postgresql_log_path
    var/"log/#{name}.log"
  end

  def pg_version_exists?
    (postgresql_datadir/"PG_VERSION").exist?
  end

  def caveats
    <<~EOS
      This formula has created a default database cluster with:
        initdb --locale=en_US.UTF-8 -E UTF-8 #{postgresql_datadir}
    EOS
  end

  service do
    run [opt_bin/"postgres", "-D", f.postgresql_datadir]
    environment_variables LC_ALL: "en_US.UTF-8"
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"initdb", "--locale=en_US.UTF-8", "-E UTF-8", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal (opt_lib/"postgresql").to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
    assert_equal (opt_include/"postgresql").to_s, shell_output("#{bin}/pg_config --pkgincludedir").chomp
    assert_equal (opt_include/"postgresql/server").to_s, shell_output("#{bin}/pg_config --includedir-server").chomp
    assert_match "-I#{Formula["gettext"].opt_include}", shell_output("#{bin}/pg_config --cppflags") if OS.mac?
  end
end
