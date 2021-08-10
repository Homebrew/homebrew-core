class Postgresql < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v13.3/postgresql-13.3.tar.bz2"
  sha256 "3cd9454fa8c7a6255b6743b767700925ead1b9ab0d7a0f9dcb1151010f8eb4a1"
  license "PostgreSQL"
  head "https://github.com/postgres/postgres.git"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_big_sur: "7c0e1b76d60b428facd521c729323221712d7f6d9954e21da389aeeb2c62348e"
    sha256 big_sur:       "eaf28965ead970ecfb327b121ec6a07f0a4e39865797a1a0383605a17e5911e3"
    sha256 catalina:      "74e946503c73cd0efc55ad4b373efbd8f4fb8a9e26a670b878c6db25794aea4a"
    sha256 mojave:        "36c7bde4788571e5b66ffe05b6174b62c69781d61c53c3ebcd9d278e8f148197"
    sha256 x86_64_linux:  "5188f5e501606d9b525e3ac16f206e9be7ae7de33c4c914053a3bb73d571bb3c"
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

    # configure patch to deal with OpenLDAP 2.5
    # (revisit on next release)
    depends_on "autoconf@2.69" => :build
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/10fe8d35eb7323bb882c909a0ec065ae01401626/postgresql/openldap-2.5.patch"
      sha256 "7b1e1a88752482c59f6971dfd17a2144ed60e6ecace8538200377ee9b1b7938c"
    end
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
    on_macos do
      args += %w[
        --with-bonjour
        --with-tcl
      ]
    end

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if MacOS.sdk_root_needed?

    on_linux do
      # rebuild `configure` after patching
      # (remove if patch block not needed)
      system "autoreconf", "-ivf"
    end

    system "./configure", *args
    system "make"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}/postgresql",
                                    "includedir=#{include}",
                                    "pkgincludedir=#{include}/postgresql",
                                    "includedir_server=#{include}/postgresql/server",
                                    "includedir_internal=#{include}/postgresql/internal"

    on_linux do
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
