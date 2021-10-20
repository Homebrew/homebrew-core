class Postgresql < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v14.0/postgresql-14.0.tar.bz2"
  sha256 "ee2ad79126a7375e9102c4db77c4acae6ae6ffe3e082403b88826d96d927a122"
  license "PostgreSQL"
  head "https://github.com/postgres/postgres.git", branch: "master"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_big_sur: "8bd4035f840a73abe180290bb7243936fa6e632e19bb4900efb0372b5cdbec4f"
    sha256 big_sur:       "879ad2903fc053e6bc172ba3331c00f5cca9d786c3a1dabe0b6a6bf82b36fd36"
    sha256 catalina:      "ec5f9890eff99ebc755cdd78dcd311f9c8c104b629e42fe08f602a5b493f16aa"
    sha256 mojave:        "d0ef5030288cf2933b60fdd4bca1ba5a0b74894d89499b5550e62d783f11177d"
    sha256 x86_64_linux:  "93065641ed70f543864124f2f1d05f62cb8ed0cfab1ec710eb8054efaee8cd46"
  end

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
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@1.1"].opt_include} -I#{Formula["readline"].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{HOMEBREW_PREFIX}/share/postgresql
      --libdir=#{HOMEBREW_PREFIX}/lib
      --includedir=#{HOMEBREW_PREFIX}/include
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
    system "make"
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
    var/"postgres"
  end

  def postgresql_log_path
    var/"log/postgres.log"
  end

  def pg_version_exists?
    (postgresql_datadir/"PG_VERSION").exist?
  end

  def caveats
    <<~EOS
      To migrate existing data from a previous major version of PostgreSQL run:
        brew postgresql-upgrade-database

      This formula has created a default database cluster with:
        initdb --locale=C -E UTF-8 #{postgresql_datadir}
      For more details, read:
        https://www.postgresql.org/docs/#{version.major}/app-initdb.html
    EOS
  end

  service do
    run [opt_bin/"postgres", "-D", var/"postgres"]
    keep_alive true
    log_path var/"log/postgres.log"
    error_log_path var/"log/postgres.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/initdb", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal "#{HOMEBREW_PREFIX}/share/postgresql", shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib", shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib/postgresql", shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
