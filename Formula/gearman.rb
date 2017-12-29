class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.18/gearmand-1.1.18.tar.gz"
  sha256 "d789fa24996075a64c5af5fd2adef10b13f77d71f7d44edd68db482b349c962c"

  bottle do
    sha256 "ecabdc718b87f1c8772a86c5cdcbfb69c538891c842132ab2a88b92fb7ebe176" => :high_sierra
    sha256 "1c1de51b9c2445c05df372a9e0f5c7d8595b4160df0515b96d014925e3e85ac8" => :sierra
    sha256 "b2d1ba15ccdf0688decb8ecb0503ffa9fe507dccb5828de1007f130266ef98b1" => :el_capitan
  end

  option "with-mysql", "Compile with MySQL persistent queue enabled"
  option "with-postgresql", "Compile with Postgresql persistent queue enabled"

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libpqxx" if build.with? "postgresql"
  depends_on "mysql" => :optional
  depends_on :postgresql => :optional
  depends_on "hiredis" => :optional
  depends_on "libmemcached" => :optional
  depends_on "openssl" => :optional
  depends_on "wolfssl" => :optional
  depends_on "tokyo-cabinet" => :optional

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    # https://bugs.launchpad.net/gearmand/+bug/1368926
    Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
      next unless /std::unique_ptr/ =~ File.read(test_file)
      inreplace test_file, "std::unique_ptr", "std::auto_ptr"
    end

    args = [
      "--prefix=#{prefix}",
      "--localstatedir=#{var}",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--disable-libdrizzle",
      "--with-boost=#{Formula["boost"].opt_prefix}",
      "--with-sqlite3",
    ]

    if build.with? "cyassl"
      args << "--enable-ssl" << "--enable-cyassl"
    elsif build.with? "openssl"
      args << "--enable-ssl" << "--with-openssl=#{Formula["openssl"].opt_prefix}" << "--disable-cyassl"
    else
      args << "--disable-ssl" << "--disable-cyassl"
    end

    if build.with? "postgresql"
      args << "--enable-libpq" << "--with-postgresql=#{Formula["postgresql"].opt_bin}/pg_config"
    else
      args << "--disable-libpq" << "--without-postgresql"
    end

    if build.with? "libmemcached"
      args << "--enable-libmemcached" << "--with-memcached=#{Formula["memcached"].opt_bin}/memcached"
    else
      args << "--disable-libmemcached" << "--without-memcached"
    end

    args << "--disable-libtokyocabinet" if build.without? "tokyo-cabinet"

    args << (build.with?("mysql") ? "--with-mysql=#{Formula["mysql"].opt_bin}/mysql_config" : "--without-mysql")
    args << (build.with?("hiredis") ? "--enable-hiredis" : "--disable-hiredis")

    ENV.append_to_cflags "-DHAVE_HTONLL"

    (var/"log").mkpath
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "gearmand -d"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/gearmand</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match /gearman\s*Error in usage/, shell_output("#{bin}/gearman --version 2>&1", 1)
  end
end
