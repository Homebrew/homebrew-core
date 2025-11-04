class PostgresqlAT14 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v14.19/postgresql-14.19.tar.bz2"
  sha256 "727e9e334bc1a31940df808259f69fe47a59f6d42174b22ae62d67fe7a01ad80"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(14(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f654ad5909a87ed4081380315edf82329301abbff4e01fd4641073ea332fb3b6"
    sha256 arm64_sequoia: "0254f39e196653fcd93ba8462fb0a33655c4b7dff7b961d21c9c53d4e473ad3f"
    sha256 arm64_sonoma:  "b6d6b2344659a64b785164918e8019d39ee039e34710c584ae05729e785dc13e"
    sha256 sonoma:        "771ebb371c41a42d72d9d1b3b9dd9dadb0298c293c9629ea479daa8b0222f9f9"
    sha256 arm64_linux:   "7ccd62cb69a764c4a73ad09ba5e21e53abe56b1966e88f6c971b7547359eaf9c"
    sha256 x86_64_linux:  "64f1d1dea887cf2d97220eb572e8cbd4e017d09ef0cc3db8707141462371dc8e"
  end

  # deprecating one year before the last release,
  # see: https://www.postgresql.org/support/versioning/
  deprecate! date: "2025-11-12", because: :unsupported
  disable! date: "2026-11-12", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "icu4c@77"

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
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac? && MacOS.sdk_root_needed?

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
