class PostgresqlAT14 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v14.20/postgresql-14.20.tar.bz2"
  sha256 "7527f10f1640761bc280ad97d105d286d0cf72e54d36d78cf68e5e5f752b646b"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(14(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "1a6d4ad311b13f9281332e42d284eda903a6a8960666cb11493fd5c957d370d2"
    sha256 arm64_sequoia: "b34086a4f4591fa20c1d7976402bbe0e8b45a3e7f8ee7ff00518d20e9a4cc34e"
    sha256 arm64_sonoma:  "f719d9a8099b836e912f8e56fbbc7a641f41c7e7a7a2aa4a38c1ea10a9741f6c"
    sha256 sonoma:        "bf608ca6db23d6a514f0b04b84e7816d99c2421a541880e2c36faa507f2b924e"
    sha256 arm64_linux:   "75d2c6d9ec6078fc4c509c0e3b369e3eeae9f6ad55f3ccbb951b2425f18c87dd"
    sha256 x86_64_linux:  "a6f480d1965dbf84d10fdcd6856faa11363a161d88be14c6da085be8db05ee18"
  end

  # deprecating one year before the last release,
  # see: https://www.postgresql.org/support/versioning/
  deprecate! date: "2025-11-12", because: :unsupported
  disable! date: "2026-11-12", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "icu4c@78"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

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

  def post_install
    (var/"log").mkpath
    postgresql_datadir.mkpath

    old_postgres_data_dir = var/"postgres"
    if old_postgres_data_dir.exist?
      opoo "The old PostgreSQL data directory (#{old_postgres_data_dir}) still exists!"
      puts <<~EOS
        Previous versions of postgresql shared the same data directory.

        You can migrate to a versioned data directory by running:
          mv -v "#{old_postgres_data_dir}" "#{postgresql_datadir}"

        (Make sure PostgreSQL is stopped before executing this command)
      EOS
    end

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
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
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
