class PostgresqlAT16 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v16.4/postgresql-16.4.tar.bz2"
  sha256 "971766d645aa73e93b9ef4e3be44201b4f45b5477095b049125403f9f3386d6f"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "e6edefb2047f4695538636c2830e3fb5522496032498aeb09bdd923cf82a1d2f"
    sha256 arm64_sonoma:  "371a0cd3cfb41549c4735703476e80be2e3c347aaad93ecfc7ae199b3704cc2c"
    sha256 arm64_ventura: "f91e841d971be121b21124baefcc5942a175210ae70c44fb1933af630995fcf5"
    sha256 sonoma:        "e8d4dab6ebc9b58957bdc0ba0730bb7a1142771f7eae3f7ae33d1ebf7edb90f7"
    sha256 ventura:       "37059a0086dbef38e2871a09770a42ba66794b99d6e90047729727d31ea70d3a"
    sha256 x86_64_linux:  "d114c8bd935ea0e911ce14c438d4006a1afe2c3789cc938a5f995b45cf49cc18"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2028-11-09", because: :unsupported

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@75"

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
  end

  def post_install
    (var/"log").mkpath
    postgresql_datadir.mkpath

    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"initdb", "--locale=C", "-E", "UTF-8", postgresql_datadir unless pg_version_exists?
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
        initdb --locale=C -E UTF-8 #{postgresql_datadir}
    EOS
  end

  service do
    run [opt_bin/"postgres", "-D", f.postgresql_datadir]
    environment_variables LC_ALL: "C"
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"initdb", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal (opt_lib/"postgresql").to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
    assert_equal (opt_include/"postgresql").to_s, shell_output("#{bin}/pg_config --pkgincludedir").chomp
    assert_equal (opt_include/"postgresql/server").to_s, shell_output("#{bin}/pg_config --includedir-server").chomp
    assert_match "-I#{Formula["gettext"].opt_include}", shell_output("#{bin}/pg_config --cppflags") if OS.mac?
  end
end
