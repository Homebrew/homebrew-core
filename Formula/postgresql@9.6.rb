class PostgresqlAT96 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v9.6.23/postgresql-9.6.23.tar.bz2"
  sha256 "a849f798401ab8c6dfa653ebbcd853b43f2200b4e3bc1ea3cb5bec9a691947b9"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(9\.6(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 arm64_big_sur: "0f79f7033fdb3a2491e28964e60c053f9c4fdc195a85f0ea67abb469cc8e0ef7"
    sha256 big_sur:       "324c559bf6e31496384cd8896329535919e6a8b2235401f59520c57f6d44d6c9"
    sha256 catalina:      "624cb85c66f1a6552dcb0ac23209d55411294b2913824ec864dbf10d2e92b569"
    sha256 mojave:        "23fdcd093f470661f6d1d663d8f5c1d63a409412ab0eaa14df8460c4c61ea52b"
    sha256 x86_64_linux:  "c761cc7491f2b55ad34c4242aac3a4574ecb15e8a7a0420e9db80cc90fdba063"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2021-11-11", because: :unsupported

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "krb5"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
  end

  def install
    # avoid adding the SDK library directory to the linker search path
    ENV["XML2_CONFIG"] = "xml2-config --exec-prefix=/usr"

    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@1.1"].opt_include} -I#{Formula["readline"].opt_include}"

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

    postgresql_datadir.mkpath
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
    run [opt_bin/"postgres", "-D", var/"postgresql@9.6"]
    keep_alive true
    log_path var/"log/postgresql@9.6.log"
    error_log_path var/"log/postgresql@9.6.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/initdb", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
