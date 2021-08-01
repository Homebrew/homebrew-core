class PostgresqlAT95 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v9.5.25/postgresql-9.5.25.tar.bz2"
  sha256 "7628c55eb23768a2c799c018988d8f2ab48ee3d80f5e11259938f7a935f0d603"
  license "PostgreSQL"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "09faf681c2893c716e88000a1e83b1beb497be61fc3b1cc1f5716192cc7ff564"
    sha256 big_sur:       "072df838f2bffda7ebd83ebef615fd39b2dab0c01724a7750a9286c7fce5c99f"
    sha256 catalina:      "d02c0da57a7e2ca6419f72d3feee3c80feff11d3a63e58ae96cf37fb73ad4d47"
    sha256 mojave:        "ffa3da3b26c1591dd5a18d28c0393584513fdeaca3670357b6f0e5225155e512"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2021-02-11", because: :unsupported

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "krb5"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"

    # configure patch to deal with OpenLDAP 2.5
    depends_on "autoconf@2.69" => :build
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/10fe8d35eb7323bb882c909a0ec065ae01401626/postgresql/openldap-2.5.patch"
      sha256 "7b1e1a88752482c59f6971dfd17a2144ed60e6ecace8538200377ee9b1b7938c"
    end
  end

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@1.1"].opt_include} -I#{Formula["readline"].opt_include}"

    # avoid adding the SDK library directory to the linker search path
    ENV["XML2_CONFIG"] = "xml2-config --exec-prefix=/usr"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{pkgshare}
      --libdir=#{lib}
      --sysconfdir=#{prefix}/etc
      --docdir=#{doc}
      --enable-thread-safety
      --with-gssapi
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

    dirs = %W[datadir=#{pkgshare} libdir=#{lib} pkglibdir=#{lib}]

    # Temporarily disable building/installing the documentation.
    # Postgresql seems to "know" the build system has been altered and
    # tries to regenerate the documentation when using `install-world`.
    # This results in the build failing:
    #  `ERROR: `osx' is missing on your system.`
    # Attempting to fix that by adding a dependency on `open-sp` doesn't
    # work and the build errors out on generating the documentation, so
    # for now let's simply omit it so we can package Postgresql for Mojave.
    on_macos do
      if DevelopmentTools.clang_build_version >= 1000
        system "make", "all"
        system "make", "-C", "contrib", "install", "all", *dirs
        system "make", "install", "all", *dirs
      else
        system "make", "install-world", *dirs
      end
    end
    on_linux do
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

      This formula has created a default database cluster with:
        initdb #{postgresql_datadir}
      For more details, read:
        https://www.postgresql.org/docs/#{version.major}/app-initdb.html
    EOS
  end

  service do
    run [opt_bin/"postgres", "-D", var/"postgresql@9.5"]
    working_dir HOMEBREW_PREFIX
    keep_alive true
    run_type :immediate
    error_log_path var/"log/postgresql@9.5.log"
  end

  test do
    system "#{bin}/initdb", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
