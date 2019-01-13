class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.18/gearmand-1.1.18.tar.gz"
  sha256 "d789fa24996075a64c5af5fd2adef10b13f77d71f7d44edd68db482b349c962c"
  revision 1

  bottle do
    sha256 "df5a14dc5c29d07d373d42888d589f6d1ec053b8965d939b6647052aa694ebf5" => :mojave
    sha256 "ecabdc718b87f1c8772a86c5cdcbfb69c538891c842132ab2a88b92fb7ebe176" => :high_sierra
    sha256 "1c1de51b9c2445c05df372a9e0f5c7d8595b4160df0515b96d014925e3e85ac8" => :sierra
    sha256 "b2d1ba15ccdf0688decb8ecb0503ffa9fe507dccb5828de1007f130266ef98b1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libmemcached"

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    # https://bugs.launchpad.net/gearmand/+bug/1368926
    Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
      next unless /std::unique_ptr/ =~ File.read(test_file)
      inreplace test_file, "std::unique_ptr", "std::auto_ptr"
    end

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-cyassl
      --disable-hiredis
      --disable-libdrizzle
      --disable-libpq
      --disable-libtokyocabinet
      --disable-ssl
      --enable-libmemcached
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-memcached=#{Formula["memcached"].opt_bin}/memcached
      --with-sqlite3
      --without-mysql
      --without-postgresql
    ]

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
