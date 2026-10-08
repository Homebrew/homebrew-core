class PostgresqlAT18 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v18.6/postgresql-18.6.tar.bz2"
  sha256 "555610c24d53e4316da5b7d3fc25c279d96856d5e0e23ee308c328c5fa881d9f"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(18(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_golden_gate: "c03f8a2999453ed0c4f0290daba750f25602e3f32ab694d99830c7d252868137"
    sha256 arm64_tahoe:       "3705effacf678f48b2667b323959d267b705e01da51ef832f10d861eba3a11a6"
    sha256 arm64_sequoia:     "11a75fdf64bdef7786c9890fca9f194cde0961fc158648509f7e8c3ffaf75275"
    sha256 arm64_linux:       "5b623e23a4a49822e8da64b982cb177592db2ac254050b1a30aa89acc9e7e873"
    sha256 x86_64_linux:      "42e9b0986f98cc8704f6d1e40730abb67c5e20b083b5a4000bb09cb5c9ad4867"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2030-11-14", because: :unsupported
  disable! date: "2031-11-14", because: :unsupported

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
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

  def install
    # Modify Makefile to link macOS binaries using Cellar path. Otherwise, binaries are linked
    # using #{HOMEBREW_PREFIX}/lib path set during ./configure, which will cause audit failures
    # for broken linkage as the paths are not created until post-install step.
    inreplace "src/Makefile.shlib", "-install_name '$(libdir)/", "-install_name '#{lib}/postgresql/"

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    ENV.runtime_cpu_detection
    ENV.delete "PKG_CONFIG_LIBDIR"
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("openssl@4")} -L#{formula_opt_lib("readline")}"
    ENV.prepend "CPPFLAGS", "-I#{formula_opt_include("openssl@4")} -I#{formula_opt_include("readline")}"

    # Fix 'libintl.h' file not found for extensions
    # Update config to fix `error: could not find function 'gss_store_cred_into' required for GSSAPI`
    if OS.mac?
      ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("gettext")} -L#{formula_opt_lib("krb5")}"
      ENV.prepend "CPPFLAGS", "-I#{formula_opt_include("gettext")} -I#{formula_opt_include("krb5")}"
    end

    args = %W[
      --datadir=#{HOMEBREW_PREFIX}/share/#{name}
      --includedir=#{HOMEBREW_PREFIX}/include/#{name}
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
      --with-libcurl
      --with-pam
      --with-perl
      --with-uuid=e2fs
    ]
    args << "--with-extra-version= (#{tap.user})" if tap
    args += %w[--with-bonjour --with-tcl] if OS.mac?

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac?

    system "./configure", *args, *std_configure_args(libdir: HOMEBREW_PREFIX/"lib/#{name}")
    system "make"
    # We use an unversioned `postgresql` subdirectory rather than `#{name}` so that the
    # post-installed symlinks can use non-conflicting `#{name}` and be retained on `brew unlink`.
    # Removing symlinks may break PostgreSQL as its binaries expect paths from ./configure step.
    system "make", "install-world", "datadir=#{share}/postgresql",
                                    "libdir=#{lib}/postgresql",
                                    "includedir=#{include}/postgresql"

    # Modify the Makefile back so dependents pick up common path
    makefile = lib/"postgresql/pgxs/src/Makefile.shlib"
    inreplace makefile, "-install_name '#{lib}/postgresql/", "-install_name '$(libdir)/"
  end

  post_install_steps do
    mkdir_p "log", base: :var
    # Manually link files from keg to non-conflicting versioned directories in HOMEBREW_PREFIX.
    # Retain existing real directories for extensions if directory structure matches
    symlink_tree "include/postgresql", "include/{{formula_name}}"
    symlink_tree "lib/postgresql", "lib/{{formula_name}}"
    symlink_tree "share/postgresql", "share/{{formula_name}}"
    # Also link versioned executables
    symlink_children "bin", suffix: "-{{version.major}}"
    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    init_data_dir formula_name, using: :postgresql, base: :var
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

      When uninstalling, some dead symlinks are left behind so you may want to run:
        brew cleanup --prune-prefix

      If the service fails to start with a "postmaster.pid" lock file error after
      an unclean shutdown, and no postgres is running, remove the stale file:
        rm #{postgresql_datadir}/postmaster.pid
    EOS
  end

  service do
    run [opt_bin/"postgres", "-D", f.postgresql_datadir]
    environment_variables LC_ALL: "en_US.UTF-8"
    # Not `true`: a stale `postmaster.pid` makes `postgres` exit 1, which would restart forever
    keep_alive crashed: true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
    stop_timeout 120
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"initdb", "--locale=en_US.UTF-8", "-E UTF-8", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    [bin/"pg_config", HOMEBREW_PREFIX/"bin/pg_config-#{version.major}"].each do |pg_config|
      assert_equal "#{HOMEBREW_PREFIX}/share/#{name}", shell_output("#{pg_config} --sharedir").chomp
      assert_equal "#{HOMEBREW_PREFIX}/lib/#{name}", shell_output("#{pg_config} --libdir").chomp
      assert_equal "#{HOMEBREW_PREFIX}/lib/#{name}", shell_output("#{pg_config} --pkglibdir").chomp
      assert_equal "#{HOMEBREW_PREFIX}/include/#{name}", shell_output("#{pg_config} --pkgincludedir").chomp
      assert_equal "#{HOMEBREW_PREFIX}/include/#{name}/server", shell_output("#{pg_config} --includedir-server").chomp
      assert_match "-I#{formula_opt_include("gettext")}", shell_output("#{pg_config} --cppflags") if OS.mac?
    end
    assert_path_exists lib/"postgresql/#{shared_library("libpq-oauth-18")}"
  end
end
