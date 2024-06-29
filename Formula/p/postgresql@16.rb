class PostgresqlAT16 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v16.3/postgresql-16.3.tar.bz2"
  sha256 "331963d5d3dc4caf4216a049fa40b66d6bcb8c730615859411b9518764e60585"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "cbb348c8dd10527f86e9c18f5d4c299959849354e9b27b061a6a5cfe19f0bf67"
    sha256 arm64_ventura:  "a2ba94a29868e33ba5461b26ec46e61d96d47e0fdbad08ffde86fa535a513306"
    sha256 arm64_monterey: "595473b2111a668604a6d1cc99f14e7e7cf3413f5e74d5d0f3ce41d23444e0c0"
    sha256 sonoma:         "55c6283de322f20316a67692aa3eb924f75aceb1ccd7da5a895d5d815acb6480"
    sha256 ventura:        "528ea472db8b98247159e922169ec855871815537cada5a1b14a0da9c4923ca8"
    sha256 monterey:       "c44ba92c5ab51d8685cb5f6b70a5ca4f4aeb187dfaf77456ad17a54de721770b"
    sha256 x86_64_linux:   "ff509480f2018fd4a13faa44b5ce406dc3900e9c6d75a5ae1a443e3b5ebaf774"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2028-11-09", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "icu4c"

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

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
  end

  def install
    # Modify Makefile to link macOS binaries using opt_lib path. Otherwise, binaries are linked
    # using #{HOMEBREW_PREFIX}/lib path set during ./configure, which will cause audit failures
    # for broken linkage as the paths are created during post-install step.
    inreplace "src/Makefile.shlib", "-install_name '$(libdir)/", "-install_name '#{opt_lib}/"

    ENV.delete "PKG_CONFIG_LIBDIR"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    # Fix 'libintl.h' file not found for extensions
    ENV.prepend "LDFLAGS", "-L#{Formula["gettext"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["gettext"].opt_include}"

    args = std_configure_args + %W[
      --datadir=#{HOMEBREW_PREFIX}/share/#{name}
      --libdir=#{HOMEBREW_PREFIX}/lib/#{name}
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
      --with-pam
      --with-perl
      --with-uuid=e2fs
      --with-extra-version=\ (#{tap.user})
    ]
    if OS.mac?
      args += %w[
        --with-bonjour
        --with-tcl
      ]
    end

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac? && MacOS.sdk_root_needed?

    system "./configure", *args
    system "make"
    # We use an unversioned `postgresql` subdirectory rather than `#{name}` so that the
    # post-installed symlinks can use non-conflicting `#{name}` and be retained on `brew unlink`.
    # Removing symlinks may break PostgreSQL as its binaries expect paths from ./configure step.
    # We also split the location of some installations (e.g. libdir and pkglibdir) to retain
    # compatibility with existing `postgresql@16` installs.
    system "make", "install-world", "datadir=#{share}/postgresql",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}/postgresql",
                                    "includedir=#{include}",
                                    "pkgincludedir=#{include}/postgresql",
                                    "includedir_server=#{include}/postgresql/server",
                                    "includedir_internal=#{include}/postgresql/internal"
    # TODO: Replace above with following in `postgresql@17` to simplify installation:
    # system "make", "install-world", "datadir=#{share}/postgresql",
    #                                 "libdir=#{lib}/postgresql",
    #                                 "includedir=#{include}/postgresql"
  end

  def post_install
    (var/"log").mkpath
    postgresql_datadir.mkpath

    # Manually link files from keg to non-conflicting versioned directories in
    # HOMEBREW_PREFIX. Existing real directories are retained for extensions.
    # Files that were installed in separate directories (e.g. libdir and pkglibdir)
    # are combined into same linked directory to match ./configure arguments.
    %w[share lib include].each do |dir|
      dst_dir = HOMEBREW_PREFIX/dir/name
      src_dir = prefix/dir/"postgresql"
      # TODO: Replace following with `src_dir.find` and remove `.sub(%r{^\.\./}, "")` in `postgresql@17`
      ((dir == "share") ? src_dir : prefix/dir).find do |src|
        dst = dst_dir/src.relative_path_from(src_dir).sub(%r{^\.\./}, "")
        next if dst.directory? && !dst.symlink? && src.directory? && !src.symlink?

        dst.rmtree if dst.exist? || dst.symlink?
        if src.symlink? || src.file?
          Find.prune if src.basename.to_s == ".DS_Store"
          dst.parent.install_symlink src
        elsif src.directory?
          dst.mkpath
        end
      end
    end

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

  def caveats
    <<~EOS
      This formula has created a default database cluster with:
        initdb --locale=C -E UTF-8 #{postgresql_datadir}
      For more details, read:
        https://www.postgresql.org/docs/#{version.major}/app-initdb.html
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
    system "#{bin}/initdb", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal "#{HOMEBREW_PREFIX}/share/#{name}", shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib/#{name}", shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib/#{name}", shell_output("#{bin}/pg_config --pkglibdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/include/#{name}", shell_output("#{bin}/pg_config --pkgincludedir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/include/#{name}/server",
                 shell_output("#{bin}/pg_config --includedir-server").chomp
    assert_match "-I#{Formula["gettext"].opt_include}", shell_output("#{bin}/pg_config --cppflags")
  end
end
