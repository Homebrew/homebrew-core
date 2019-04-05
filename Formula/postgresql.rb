class Postgresql < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v11.2/postgresql-11.2.tar.bz2"
  sha256 "2676b9ce09c21978032070b6794696e0aa5a476e3d21d60afc036dc0a9c09405"
  head "https://github.com/postgres/postgres.git"

  bottle do
    sha256 "8fd1cacd7b9aa9325c9ddcc1c3fabbc0f76d70898cb45aa476ef53ffef7983b5" => :mojave
    sha256 "08d79f786ec1cee0d836101040e544b52e33527ed0612ca3283237e11455fa15" => :high_sierra
    sha256 "3941b3241eec502036ad48abec93b6bc5cfce831ab354a5db9f358e41422b95b" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl"
  depends_on "readline"

  conflicts_with "postgres-xc",
    :because => "postgresql and postgres-xc install the same binaries."

  def install
    # avoid adding the SDK library directory to the linker search path
    ENV["XML2_CONFIG"] = "xml2-config --exec-prefix=/usr"

    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include} -I#{Formula["readline"].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{HOMEBREW_PREFIX}/share/postgresql
      --libdir=#{HOMEBREW_PREFIX}/lib
      --sysconfdir=#{etc}
      --docdir=#{doc}
      --enable-thread-safety
      --with-bonjour
      --with-gssapi
      --with-icu
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

    system "./configure", *args
    system "make"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}/postgresql"
  end

  def post_install
    (var/"log").mkpath
    (var/"postgres").mkpath
    unless File.exist? "#{var}/postgres/PG_VERSION"
      system "#{bin}/initdb", "--locale=C", "-E", "UTF-8", "#{var}/postgres", 
    end
  end

  def caveats; <<~EOS
    To migrate existing data from a previous major version of PostgreSQL run:
      brew postgresql-upgrade-database
  EOS
  end

  plist_options :manual => "pg_ctl -D #{HOMEBREW_PREFIX}/var/postgres start"

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
        <string>#{var}/postgres</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/postgres.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/postgres.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/initdb", testpath/"test"
    assert_equal "#{HOMEBREW_PREFIX}/share/postgresql", shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib", shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib/postgresql", shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
