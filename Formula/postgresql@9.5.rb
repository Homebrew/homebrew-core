class PostgresqlAT95 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v9.5.19/postgresql-9.5.19.tar.bz2"
  sha256 "960caa26612bca8a3791d1c0bdc5c6d24b3d15841becb617470424edbc5e1bb3"
  revision 1

  bottle do
    sha256 "b452721c1d4c4307da0531e4f21a20be3222c9e449f1f67ab3bf7a6203c1bf06" => :mojave
    sha256 "e165bf3d617cf38bb20a6319ae03d60f3a5b2ed73c06c9e9e75702462a515779" => :high_sierra
    sha256 "7e710fd52bedb37ffec44fa9b578da336b2d3ba59e13a4ab380c3a6f88cee645" => :sierra
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "readline"

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
      --with-bonjour
      --with-gssapi
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-openssl
      --with-pam
      --with-perl
      --with-uuid=e2fs
    ]

    # The CLT is required to build Tcl support on 10.7 and 10.8 because
    # tclConfig.sh is not part of the SDK
    args << "--with-tcl"
    if File.exist?("#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/tclConfig.sh")
      args << "--with-tclconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    end

    # As of Xcode/CLT 10.x the Perl headers were moved from /System
    # to inside the SDK, so we need to use `-iwithsysroot` instead
    # of `-I` to point to the correct location.
    # https://www.postgresql.org/message-id/153558865647.1483.573481613491501077%40wrigleys.postgresql.org
    if DevelopmentTools.clang_build_version >= 1000
      inreplace "configure",
                "-I$perl_archlibexp/CORE",
                "-iwithsysroot $perl_archlibexp/CORE"
      inreplace "contrib/hstore_plperl/Makefile",
                "$(perl_archlibexp)/CORE",
                "-iwithsysroot $(perl_archlibexp)/CORE"
      inreplace "src/pl/plperl/GNUmakefile",
                "$(perl_archlibexp)/CORE",
                "-iwithsysroot $(perl_archlibexp)/CORE"
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
    if DevelopmentTools.clang_build_version >= 1000
      system "make", "all"
      system "make", "-C", "contrib", "install", "all", *dirs
      system "make", "install", "all", *dirs
    else
      system "make", "install-world", *dirs
    end
  end

  def post_install
    (var/"log").mkpath
    (var/name).mkpath
    unless File.exist? "#{var}/#{name}/PG_VERSION"
      system "#{bin}/initdb", "#{var}/#{name}"
    end
  end

  def caveats; <<~EOS
    If builds of PostgreSQL 9 are failing and you have version 8.x installed,
    you may need to remove the previous version first. See:
      https://github.com/Homebrew/legacy-homebrew/issues/2510

    To migrate existing data from a previous major version (pre-9.0) of PostgreSQL, see:
      https://www.postgresql.org/docs/9.5/static/upgrading.html

    To migrate existing data from a previous minor version (9.0-9.4) of PostgreSQL, see:
      https://www.postgresql.org/docs/9.5/static/pgupgrade.html

      You will need your previous PostgreSQL installation from brew to perform `pg_upgrade`.
      Do not run `brew cleanup postgresql@9.5` until you have performed the migration.
  EOS
  end

  plist_options :manual => "pg_ctl -D #{HOMEBREW_PREFIX}/var/postgresql@9.5 start"

  def plist; <<~EOS
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
    system "#{bin}/initdb", testpath/"test"
    assert_equal pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal lib.to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
