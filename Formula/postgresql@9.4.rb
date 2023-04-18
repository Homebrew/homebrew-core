class PostgresqlAT94 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v9.4.26/postgresql-9.4.26.tar.bz2"
  sha256 "f5c014fc4a5c94e8cf11314cbadcade4d84213cfcc82081c9123e1b8847a20b9"
  license "PostgreSQL"

  bottle do
    rebuild 4
    sha256 monterey:     "6b8c02385f043c6ddf224b48f79dce675f9f6a18a2fcbd9b9cfdbb52ec57663e"
    sha256 big_sur:      "0331cf3d1dcb6311ad144916317c520c0a442832d038c6d11da6f42c670e263f"
    sha256 catalina:     "a72c3df7772799a0870db56245b192b655c7691984224f6eb0b9a3f839edb8a3"
    sha256 mojave:       "64558f09195403c05cea3f52cb7c7162a61a0a01e24a40aaf297021fadf11fc9"
    sha256 x86_64_linux: "fddd8da997370fa7185ce58a2cb5a2f3a95d4d24d9e20eae8dd368004682d1f9"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  disable! date: "2022-07-31", because: :unsupported

  depends_on arch: :x86_64
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "krb5"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "autoconf@2.69" => :build
    depends_on "linux-pam"
    depends_on "util-linux"

    # configure patch to deal with OpenLDAP 2.5
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/10fe8d35eb7323bb882c909a0ec065ae01401626/postgresql/openldap-2.5.patch"
      sha256 "7b1e1a88752482c59f6971dfd17a2144ed60e6ecace8538200377ee9b1b7938c"
    end
  end

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@1.1"].opt_include} -I#{Formula["readline"].opt_include}"
    ENV.prepend "PG_SYSROOT", MacOS.sdk_path
    ENV.append_to_cflags "-D_XOPEN_SOURCE"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{pkgshare}
      --docdir=#{doc}
      --enable-thread-safety
      --with-gssapi
      --with-ldap
      --with-openssl
      --with-pam
      --with-libxml
      --with-libxslt
      --with-perl
      --with-uuid=e2fs
    ]

    if OS.mac?
      args += %w[
        --with-bonjour
        --with-tcl
      ]

      # The CLT is required to build tcl support on 10.7 and 10.8 because tclConfig.sh is not part of the SDK
      if File.exist?("#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/tclConfig.sh")
        args << "--with-tclconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
      end

      # configure issue with CLT 12+
      if DevelopmentTools.clang_build_version >= 1200
        inreplace "configure",
                  "exit(! does_int64_work())",
                  "return(! does_int64_work())"
      end
    else
      # rebuild `configure` after patching
      # (remove if patch block not needed)
      system "autoreconf", "-ivf"
    end

    system "./configure", *args
    system "make"

    dirs = %W[datadir=#{pkgshare} libdir=#{lib} pkglibdir=#{lib}]

    # Temporarily disable building/installing the documentation.
    # Postgresql seems to "know" the build system has been altered and
    # tries to regenerate the documentation when using `install-world`.
    # This results in the build failing:
    #  `ERROR: `osx' is missing on your system.`
    # Attempting to fix that by adding a dependency on `open-sp` doesn't
    # work and the build errors out on generating the documentation, so
    # for now let's simply omit it so we can package Postgresql for Mojave.
    if OS.mac?
      if DevelopmentTools.clang_build_version >= 1000
        system "make", "all"
        system "make", "-C", "contrib", "install", "all", *dirs
        system "make", "install", "all", *dirs
      else
        system "make", "install-world", *dirs
      end
    else
      system "make", "all"
      system "make", "-C", "contrib", "install", "all", *dirs
      system "make", "install", "all", *dirs
      inreplace lib/"pgxs/src/Makefile.global",
                "LD = #{HOMEBREW_PREFIX}/Homebrew/Library/Homebrew/shims/linux/super/ld",
                "LD = #{HOMEBREW_PREFIX}/bin/ld"
    end
  end

  def post_install
    (var/"log").mkpath
    postgresql_datadir.mkpath

    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/initdb", postgresql_datadir unless pg_version_exists?
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
      If builds of PostgreSQL 9 are failing and you have version 8.x installed,
      you may need to remove the previous version first. See:
        https://github.com/Homebrew/legacy-homebrew/issues/2510

      When installing the postgres gem, including ARCHFLAGS is recommended:
        ARCHFLAGS="-arch x86_64" gem install pg

      To install gems without sudo, see the Homebrew documentation:
        https://docs.brew.sh/Gems,-Eggs-and-Perl-Modules

      This formula has created a default database cluster with:
        initdb #{postgresql_datadir}
      For more details, read:
        https://www.postgresql.org/docs/#{version.major}/app-initdb.html
    EOS
  end

  service do
    run [opt_bin/"postgres", "-D", var/"postgresql@9.4"]
    working_dir HOMEBREW_PREFIX
    keep_alive true
    run_type :immediate
    error_log_path var/"log/postgresql@9.4.log"
  end

  test do
    system "#{bin}/initdb", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
