class PostgresqlAT12 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v12.11/postgresql-12.11.tar.bz2"
  sha256 "1026248a5fd2beeaf43e4c7236ac817e56d58b681a335856465dfbc75b3e8302"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(12(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "4bc7c549bb8425c5b56438a5d225c1f089824ca1ae258f9def6186b236931f9c"
    sha256 arm64_big_sur:  "be096fde0cca6777a23403e3fe2f0a29acc4bc7b739f385b1e314fe2c6d64621"
    sha256 monterey:       "03979650f2154f90bc1c73200c7296840fefa6aa4f18af00abb023a63685097a"
    sha256 big_sur:        "d881638cf922162400d50d14293f59bb0e0dd820b0ced7a8e8b94c615663a3b9"
    sha256 catalina:       "35dc8c65ab59d14c150d5e3479434a8a02068b3b91ca7e9377a76a248715982b"
    sha256 x86_64_linux:   "9ba52352fe12ad3879c78d4eef35128ee0489268a58b72c23b3eb0285900b08e"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2024-11-14", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "icu4c"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
  end

  def install
    ENV.delete "PKG_CONFIG_LIBDIR" if MacOS.version == :catalina
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@1.1"].opt_include} -I#{Formula["readline"].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{opt_pkgshare}
      --libdir=#{opt_lib}
      --includedir=#{opt_include}
      --sysconfdir=#{etc}
      --docdir=#{doc}
      --enable-thread-safety
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-openssl
      --with-pam
      --with-perl
      --with-uuid=e2fs
    ]
    if OS.mac?
      args += %w[
        --with-bonjour
        --with-tcl
      ]
    end

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if MacOS.sdk_root_needed?

    system "./configure", *args

    # Work around busted path magic in Makefile.global.in. This can't be specified
    # in ./configure, but needs to be set here otherwise install prefixes containing
    # the string "postgres" will get an incorrect pkglibdir.
    # See https://github.com/Homebrew/homebrew-core/issues/62930#issuecomment-709411789
    system "make", "pkglibdir=#{lib}/postgresql"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}/postgresql",
                                    "includedir=#{include}",
                                    "pkgincludedir=#{include}/postgresql",
                                    "includedir_server=#{include}/postgresql/server",
                                    "includedir_internal=#{include}/postgresql/internal"

    if OS.linux?
      inreplace lib/"postgresql/pgxs/src/Makefile.global",
                "LD = #{HOMEBREW_PREFIX}/Homebrew/Library/Homebrew/shims/linux/super/ld",
                "LD = #{HOMEBREW_PREFIX}/bin/ld"
    end
  end

  def post_install
    (var/"log").mkpath
    postgresql_datadir.mkpath

    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/initdb", "--locale=C", "-E", "UTF-8", postgresql_datadir unless pg_version_exists?
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

  def old_postgres_data_dir
    var/"postgres"
  end

  def postgresql_formula_present?
    Formula["postgresql"].any_version_installed?
  end

  # Figure out what version of PostgreSQL the old data dir is
  # using
  def old_postgresql_datadir_version
    pg_version = old_postgres_data_dir/"PG_VERSION"
    pg_version.exist? && pg_version.read.chomp
  end

  def caveats
    caveats = ""

    # Extract the version from the formula name
    pg_formula_version = name.split("@", 2).last
    # ... and check it against the old data dir postgres version number
    # to see if we need to print a warning re: data dir
    if old_postgresql_datadir_version == pg_formula_version
      caveats += if postgresql_formula_present?
        # Both PostgreSQL and PostgreSQL@12 are installed
        <<~EOS
          Previous versions of this formula used the same data directory as
          the regular PostgreSQL formula. This causes a conflict if you
          try to use both at the same time.

          In order to avoid this conflict, you should make sure that the
          #{name} data directory is located at:
            #{postgresql_datadir}

        EOS
      else
        # Only PostgreSQL@12 is installed, not PostgreSQL
        <<~EOS
          Previous versions of #{name} used the same data directory as
          the postgresql formula. This will cause a conflict if you
          try to use both at the same time.

          You can migrate to a versioned data directory by running:
            mv -v "#{old_postgres_data_dir}" "#{postgresql_datadir}"

          (Make sure PostgreSQL is stopped before executing this command)

        EOS
      end
    end

    caveats += <<~EOS
      This formula has created a default database cluster with:
        initdb --locale=C -E UTF-8 #{postgresql_datadir}
      For more details, read:
        https://www.postgresql.org/docs/#{version.major}/app-initdb.html
    EOS

    caveats
  end

  service do
    run [opt_bin/"postgres", "-D", var/"postgresql@12"]
    keep_alive true
    log_path var/"log/postgresql@12.log"
    error_log_path var/"log/postgresql@12.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/initdb", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal "#{lib}/postgresql", shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
