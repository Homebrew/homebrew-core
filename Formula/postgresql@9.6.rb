class PostgresqlAT96 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v9.6.19/postgresql-9.6.19.tar.bz2"
  sha256 "61f93a94ccddbe0b2d1afaf03f04ba605d8af5b774ff9b830e5adeb50ab55cb0"
  license "PostgreSQL"

  livecheck do
    url "https://www.postgresql.org/docs/9.6/static/release.html"
    regex(/Release v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 "81b3a3ac4e549641e48fe4f291b32266603858cff2ceb6242f2725deb20bdd9a" => :catalina
    sha256 "b515085fd803628a5979a34402fa7296e95c437bc5805ec08acd69b43ac11c6a" => :mojave
    sha256 "59593120c3bce07fa0c130eda3f1b0aef1cc2ed254b822fd9ed416d7469a8da2" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxslt"
  uses_from_macos "perl"

  on_linux do
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
      --with-bonjour
      --with-gssapi
      --with-ldap
      --with-openssl
      --with-pam
      --with-libxml
      --with-libxslt
      --with-perl
      --with-tcl
      --with-uuid=e2fs
    ]

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
    if DevelopmentTools.clang_build_version >= 1000
      system "make", "all"
      system "make", "-C", "contrib", "install", "all", *dirs
      system "make", "install", "all", *dirs
    else
      system "make", "install-world", *dirs
    end
  end

  def post_install
    return if ENV["CI"]

    (var/"log").mkpath
    (var/name).mkpath
    system "#{bin}/initdb", "#{var}/#{name}" unless File.exist? "#{var}/#{name}/PG_VERSION"
  end

  def caveats
    <<~EOS
      If builds of PostgreSQL 9 are failing and you have version 8.x installed,
      you may need to remove the previous version first. See:
        https://github.com/Homebrew/legacy-homebrew/issues/2510

      To migrate existing data from a previous major version (pre-9.0) of PostgreSQL, see:
        https://www.postgresql.org/docs/9.6/static/upgrading.html

      To migrate existing data from a previous minor version (9.0-9.5) of PostgreSQL, see:
        https://www.postgresql.org/docs/9.6/static/pgupgrade.html

        You will need your previous PostgreSQL installation from brew to perform `pg_upgrade`.
          Do not run `brew cleanup postgresql@9.6` until you have performed the migration.

      This formula has created a default database cluster with:
        initdb #{var}/postgres
      For more details, read:
        https://www.postgresql.org/docs/#{version.major}/app-initdb.html
    EOS
  end

  plist_options manual: "pg_ctl -D #{HOMEBREW_PREFIX}/var/postgresql@9.6 start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/postgres</string>
          <string>-D</string>
          <string>#{var}/#{name}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/#{name}.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/initdb", testpath/"test" unless ENV["CI"]
    assert_equal pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
