class PostgresqlAT14 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v14.23/postgresql-14.23.tar.bz2"
  sha256 "cc7216822b546330e29c2f91e123c8734a4c41795082145bb962aa712e8c94a5"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(14(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "dc282cc6fdf7a2a982622d6a9c94fe3d580461c218aa9f3923da50cac415b3c4"
    sha256 arm64_sequoia: "72ab7d81ddad9c873c2860a9aadf0b7b77459e473f7d09a310547fa39cd0ae82"
    sha256 arm64_sonoma:  "a7f2436d23c5b34bc34ee4874653ab2f5d9817bfb6976d6d7b91fdcbd7bd2e25"
    sha256 sonoma:        "0cba3c377a0bc772201df99f070a2e1690102c59bc05768533c8cb05184344b1"
    sha256 arm64_linux:   "01608f2ea0c2ece2612005e7d62816558bbfd972bd0d138b7ff8b25e9a7d972c"
    sha256 x86_64_linux:  "d8e5563eb58a4165095c387b6afcaada3d664d8a562682aede9286c7fbc2b9b5"
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

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("openssl@3")} -L#{formula_opt_lib("readline")}"
    ENV.prepend "CPPFLAGS", "-I#{formula_opt_include("openssl@3")} -I#{formula_opt_include("readline")}"

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
    mkdir_p "log"
    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    init_data_dir "postgresql@14", using: :postgresql_initdb
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
