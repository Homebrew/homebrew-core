class PostgresqlAT12 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v12.5/postgresql-12.5.tar.bz2"
  sha256 "bd0d25341d9578b5473c9506300022de26370879581f5fddd243a886ce79ff95"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(12(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 "6e1717130028267c3f8c3910e10909fde608892da4af2669842da0dca386392a" => :big_sur
    sha256 "27658e4805d15ad69c7cd07c9eb0f76704e9976007c492f190cf2268e980beee" => :arm64_big_sur
    sha256 "197b8aed9485281f776878374357955084177c0a28fd7ddcc8c8f4f24f749c63" => :catalina
    sha256 "b00c52d0070387e5eb4a2057e634ba637cb71eccc97aff7999cb3a8600cba1fe" => :mojave
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
  uses_from_macos "perl"

  on_linux do
    depends_on "util-linux"
  end

  def install
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
      --with-bonjour
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-openssl
      --with-pam
      --with-perl
      --with-tcl
      --with-uuid=e2fs
    ]

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
  end

  def post_install
    return if ENV["CI"]

    (var/"log").mkpath
    versioned_data_dir.mkpath
    system "#{bin}/initdb", "--locale=C", "-E", "UTF-8", versioned_data_dir unless versioned_pg_version_exists?
  end

  # Previous versions of this formula used the same data dir as the regular
  # postgresql formula. So we check whether the versioned data dir exists
  # and has a PG_VERSION file, which should indicate that the versioned
  # data dir is in use. Otherwise, returns the old data dir path.
  def postgresql_datadir
    if versioned_pg_version_exists?
      versioned_data_dir
    else
      old_postgres_data_dir
    end
  end

  def versioned_data_dir
    var/name
  end

  def old_postgres_data_dir
    var/"postgres"
  end

  # Same as with the data dir - use old log file if the old data dir
  # is version 12
  def postgresql_log_path
    if versioned_pg_version_exists?
      var/"log/#{name}.log"
    else
      var/"log/postgres.log"
    end
  end

  def versioned_pg_version_exists?
    (versioned_data_dir/"PG_VERSION").exist?
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
            #{versioned_data_dir}

        EOS
      else
        # Only PostgreSQL@12 is installed, not PostgreSQL
        <<~EOS
          Previous versions of #{name} used the same data directory as
          the postgresql formula. This will cause a conflict if you
          try to use both at the same time.

          You can migrate to a versioned data directory by running:
            mv -v "#{old_postgres_data_dir}" "#{versioned_data_dir}"

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

  plist_options manual: "pg_ctl -D #{HOMEBREW_PREFIX}/var/postgres@12 start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/postgres</string>
          <string>-D</string>
          <string>#{postgresql_datadir}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardOutPath</key>
        <string>#{postgresql_log_path}</string>
        <key>StandardErrorPath</key>
        <string>#{postgresql_log_path}</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/initdb", testpath/"test" unless ENV["CI"]
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal "#{lib}/postgresql", shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
