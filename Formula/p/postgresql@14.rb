class PostgresqlAT14 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v14.25/postgresql-14.25.tar.bz2"
  sha256 "09af980eb3a5d0a8ad7a34b95031b1988bbcd430c87700a62d6234c0ed97ae4c"
  license "PostgreSQL"

  bottle do
    sha256 arm64_golden_gate: "cf94f2f017c73452d344292999128c43999d2f5bb2fd0fe6d08a9730fa7ddf4d"
    sha256 arm64_tahoe:       "f7f90fe2dbed89be87146f68256044ac35e2baffc10eed12322d5e6f971d537a"
    sha256 arm64_sequoia:     "712ac08614d28e980d7869afc39475958c9f434143212520b77594b8c51aff7b"
    sha256 arm64_linux:       "d88a122cc49cc38bb50f7d1d3ccc39752c92d9f60982266e875f70b786f5a10b"
    sha256 x86_64_linux:      "22ed6d4e38be470b69026d7a7b168b462ded51b601dd2fc542c35dee3b2850c4"
  end

  # deprecating one year before the last release,
  # see: https://www.postgresql.org/support/versioning/
  deprecate! date: "2025-11-12", because: :unsupported
  disable! date: "2026-11-30", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "icu4c@79"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("openssl@4")} -L#{formula_opt_lib("readline")}"
    ENV.prepend "CPPFLAGS", "-I#{formula_opt_include("openssl@4")} -I#{formula_opt_include("readline")}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{HOMEBREW_PREFIX}/share/#{name}
      --libdir=#{HOMEBREW_PREFIX}/lib/#{name}
      --includedir=#{HOMEBREW_PREFIX}/include/#{name}
      --enable-thread-safety
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-lz4
      --with-openssl
      --with-pam
      --with-perl
      --with-uuid=e2fs
      --with-extra-version=\ (#{tap.user})
    ]
    args += %w[--with-bonjour --with-tcl] if OS.mac?

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}/#{name}",
                                    "pkglibdir=#{lib}/#{name}",
                                    "includedir=#{include}/#{name}",
                                    "pkgincludedir=#{include}/#{name}",
                                    "includedir_server=#{include}/#{name}/server",
                                    "includedir_internal=#{include}/#{name}/internal"
    return unless OS.linux?

    inreplace lib/name/"pgxs/src/Makefile.global",
              "LD = #{Superenv.shims_path}/ld",
              "LD = #{HOMEBREW_PREFIX}/bin/ld"
  end

  post_install_steps do
    mkdir_p "log", base: :var
    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    init_data_dir "postgresql@14", using: :postgresql, base: :var
  end

  def postgresql_datadir
    var/name
  end

  def postgresql_log_path
    var/"log/#{name}.log"
  end

  def caveats
    old_postgres_data_dir = var/"postgres"
    <<~EOS
      If an old PostgreSQL data directory (#{old_postgres_data_dir}) still exists,
      you can migrate to a versioned data directory by running:
        mv -v "#{old_postgres_data_dir}" "#{postgresql_datadir}"

      (Make sure PostgreSQL is stopped before executing this command)

      This formula has created a default database cluster with:
        initdb --locale=en_US.UTF-8 -E UTF-8 #{postgresql_datadir}
    EOS
  end

  service do
    run [opt_bin/"postgres", "-D", f.postgresql_datadir]
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
    stop_timeout 120
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"initdb", "--locale=en_US.UTF-8", "-E UTF-8", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal "#{HOMEBREW_PREFIX}/share/#{name}", shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib/#{name}", shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib/#{name}", shell_output("#{bin}/pg_config --pkglibdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/include/#{name}", shell_output("#{bin}/pg_config --includedir").chomp
  end
end
