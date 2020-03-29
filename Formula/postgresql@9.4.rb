class PostgresqlAT94 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v9.4.26/postgresql-9.4.26.tar.bz2"
  sha256 "f5c014fc4a5c94e8cf11314cbadcade4d84213cfcc82081c9123e1b8847a20b9"

  bottle do
    rebuild 1
    sha256 "3c32ebc27f39fa609d19bdc1369a9bac3c4836908ae2456e44a53d3a368d0157" => :catalina
    sha256 "ee5a9ae06d5324bac569d515ea3de348bb97010044075f791d089352c1a0c967" => :mojave
    sha256 "03efe44c1c036c9dde08bed7932e34365be47365da98d85f30fc0f0aa2a08da7" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxslt"
  uses_from_macos "perl"

  def install
    # Fix "configure: error: readline library not found"
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra || MacOS.version == :el_capitan

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
      --with-bonjour
      --with-gssapi
      --with-ldap
      --with-openssl
      --with-pam
      --with-libxml
      --with-libxslt
      --with-perl
      --with-uuid=e2fs
    ]

    # The CLT is required to build tcl support on 10.7 and 10.8 because tclConfig.sh is not part of the SDK
    args << "--with-tcl"
    if File.exist?("#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/tclConfig.sh")
      args << "--with-tclconfig=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    end

    system "./configure", *args
    system "make", "install-world"
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

      To migrate existing data from a previous major version (pre-9.3) of PostgreSQL, see:
        https://www.postgresql.org/docs/9.3/static/upgrading.html

      When installing the postgres gem, including ARCHFLAGS is recommended:
        ARCHFLAGS="-arch x86_64" gem install pg

      To install gems without sudo, see the Homebrew documentation:
        https://docs.brew.sh/Gems,-Eggs-and-Perl-Modules
    EOS
  end

  plist_options :manual => "pg_ctl -D #{HOMEBREW_PREFIX}/var/postgresql@9.4 start"

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
  end
end
