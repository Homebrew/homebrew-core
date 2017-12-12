class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.18/gearmand-1.1.18.tar.gz"
  sha256 "d789fa24996075a64c5af5fd2adef10b13f77d71f7d44edd68db482b349c962c"

  bottle do
    sha256 "91bbdfb493befa2b4f45c68b43182dc2df36af5a72b0c28e4dd97adcdc9eb3ed" => :high_sierra
    sha256 "529a37d7f9648ed0371529bab74b12173ca3ead3c9d6bd4e193f2097c0a9fe83" => :sierra
    sha256 "8f70079e03761e0711231a5ca77f450e490bfeb4e668e4be9c8ce6de2ef52fee" => :el_capitan
    sha256 "12616febecef3a1a5951296bf3f7efa30637688318713969c74931b95f01313f" => :yosemite
  end

  option "with-mysql", "Compile with MySQL persistent queue enabled"
  option "with-postgresql", "Compile with Postgresql persistent queue enabled"

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libpqxx" if build.with? "postgresql"
  depends_on :mysql => :optional
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
