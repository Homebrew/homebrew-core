class PostgresqlAT17 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v17.7/postgresql-17.7.tar.bz2"
  sha256 "ef9e343302eccd33112f1b2f0247be493cb5768313adeb558b02de8797a2e9b5"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(17(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "fe0e1c07ec222d8462c9d3781df02c891ace6a30a972493213713ac4463d6b1f"
    sha256 arm64_sequoia: "dc25244bf06569a8886bb2d0dd4d361f6ca6ffc4040208a4a2f67d29c1393447"
    sha256 arm64_sonoma:  "64e75b4b51670974d1a4ca75f1f67ced14c4a8d65be998f95db93d40be40f51a"
    sha256 sonoma:        "ecd08b49055c62ff3682d21e0f24f60873ec79f90d66a8658cb9f6264c35eafc"
    sha256 arm64_linux:   "913ef72e2702e11d50a0ccf444f24eb2c81fbbc58855275230130908e6f767c3"
    sha256 x86_64_linux:  "187bb9fbc2edb394d7de6ecc33c746fead3d1503368dedda4ad3c5571ee6b73e"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2029-11-08", because: :unsupported

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
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
    # Modify Makefile to link macOS binaries using Cellar path. Otherwise, binaries are linked
    # using #{HOMEBREW_PREFIX}/lib path set during ./configure, which will cause audit failures
    # for broken linkage as the paths are not created until post-install step.
    inreplace "src/Makefile.shlib", "-install_name '$(libdir)/", "-install_name '#{lib}/postgresql/"

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    ENV.runtime_cpu_detection
    ENV.delete "PKG_CONFIG_LIBDIR"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    # Fix 'libintl.h' file not found for extensions
    # Update config to fix `error: could not find function 'gss_store_cred_into' required for GSSAPI`
    if OS.mac?
      ENV.prepend "LDFLAGS", "-L#{Formula["gettext"].opt_lib} -L#{Formula["krb5"].opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["gettext"].opt_include} -I#{Formula["krb5"].opt_include}"
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

  def post_install
    (var/"log").mkpath
    postgresql_datadir.mkpath

    # Manually link files from keg to non-conflicting versioned directories in HOMEBREW_PREFIX.
    %w[include lib share].each do |dir|
      dst_dir = HOMEBREW_PREFIX/dir/name
      src_dir = prefix/dir/"postgresql"
      src_dir.find do |src|
        dst = dst_dir/src.relative_path_from(src_dir)

        # Retain existing real directories for extensions if directory structure matches
        next if dst.directory? && !dst.symlink? && src.directory? && !src.symlink?

        rm_r(dst) if dst.exist? || dst.symlink?
        if src.symlink? || src.file?
          Find.prune if src.basename.to_s == ".DS_Store"
          dst.parent.install_symlink src
        elsif src.directory?
          dst.mkpath
        end
      end
    end

    # Also link versioned executables
    bin.each_child { |f| (HOMEBREW_PREFIX/"bin").install_symlink f => "#{f.basename}-#{version.major}" }

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

      When uninstalling, some dead symlinks are left behind so you may want to run:
        brew cleanup --prune-prefix
    EOS
  end

  service do
    run [opt_bin/"postgres", "-D", f.postgresql_datadir]
    environment_variables LC_ALL: "en_US.UTF-8"
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
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
      assert_match "-I#{Formula["gettext"].opt_include}", shell_output("#{pg_config} --cppflags") if OS.mac?
    end
  end
end
