class PostgresqlAT16 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v16.15/postgresql-16.15.tar.bz2"
  sha256 "c1575341fa7bd40f5274ea465b34390f4dc64cdd0770af327005caaeb9f6b7ed"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "31b8c98844e409376dc0fc7801e09f25c5c7b3c175c77b929ad9bb51aef3095d"
    sha256 arm64_tahoe:       "3c9aa633ef3cbd79fb711114de4fd1e5d522a38b742fd2dce4f2bc980c4558db"
    sha256 arm64_sequoia:     "9b7191bfb6e0ffa6ba4760d649a159cbcf4ecb2740f6ed16bc82ed432dab6f36"
    sha256 arm64_linux:       "4d35e662eadc1ad5f0f508a337abce79f6a07c6c24e66ce07abad963d6e3ae6a"
    sha256 x86_64_linux:      "b7bb7eef65d8fae9ab3bb80c72ee5dfe5da13d66e40e9ba81522d624f39971ec"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2028-11-09", because: :unsupported
  disable! date: "2029-11-09", because: :unsupported

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@79"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    ENV.runtime_cpu_detection
    ENV.delete "PKG_CONFIG_LIBDIR"

    flag_libs = [openssl, "readline"]

    # Fix 'libintl.h' file not found for extensions
    # Update config to fix `error: could not find function 'gss_store_cred_into' required for GSSAPI`
    flag_libs += ["gettext", "krb5"] if OS.mac?

    flag_libs.each do |l|
      ENV.prepend "LDFLAGS", "-L#{formula_opt_lib(l)}"
      ENV.prepend "CPPFLAGS", "-I#{formula_opt_include(l)}"
    end

    args = %W[
      --datadir=#{opt_pkgshare}
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
    ]
    args << "--with-extra-version= (#{tap.user})" if tap
    args += %w[--with-bonjour --with-tcl] if OS.mac?

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac?

    system "./configure", *args, *std_configure_args(libdir: opt_lib)

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
  end

  post_install_steps do
    mkdir_p "log", base: :var
    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    init_data_dir "postgresql@16", using: :postgresql, base: :var
  end

  def postgresql_datadir
    var/name
  end

  def postgresql_log_path
    var/"log/#{name}.log"
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
    stop_timeout 120
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"initdb", "--locale=en_US.UTF-8", "-E UTF-8", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal (opt_lib/"postgresql").to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
    assert_equal (opt_include/"postgresql").to_s, shell_output("#{bin}/pg_config --pkgincludedir").chomp
    assert_equal (opt_include/"postgresql/server").to_s, shell_output("#{bin}/pg_config --includedir-server").chomp
    assert_match "-I#{formula_opt_include("gettext")}", shell_output("#{bin}/pg_config --cppflags") if OS.mac?
  end
end
