class H2o < Formula
  desc "HTTP server with support for HTTP/1.x and HTTP/2"
  homepage "https://github.com/h2o/h2o/"

  stable do
    url "https://github.com/h2o/h2o/archive/v2.0.6.tar.gz"
    sha256 "bf4f2dc3b2f1a6886eb7ee6487cb6ba4b206700055a1d2ca9c2a99a82d21055b"

    depends_on "openssl"
  end

  bottle do
    sha256 "72a73995197aa85a33a933309cc6439a2d9ba0e4df62e2fcdb11cfa14d985870" => :sierra
    sha256 "915b71553d0fc0e7f815a1d2c64486ef87c6e61f40a6ab0fb2d2860166c93eba" => :el_capitan
    sha256 "b090435d46399fa5098b5c5c27aa329464f65c16f9c658a2d1810ff5593f284b" => :yosemite
  end

  devel do
    url "https://github.com/h2o/h2o/archive/v2.1.0-beta4.tar.gz"
    version "2.1.0-beta4"
    sha256 "780d4b210f1a9b76a1a29cad794305631afb739c79b3835902b13aaf01507e60"

    depends_on "openssl@1.1"
  end

  option "with-libuv", "Build the H2O library in addition to the executable"
  option "without-mruby", "Don't build the bundled statically-linked mruby"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libuv" => :optional
  depends_on "wslay" => :optional

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    # https://github.com/Homebrew/brew/pull/251
    ENV.delete("SDKROOT")

    args = std_cmake_args
    args << "-DWITH_BUNDLED_SSL=OFF"
    args << "-DWITH_MRUBY=OFF" if build.without? "mruby"

    system "cmake", *args

    if build.with? "libuv"
      system "make", "libh2o"
      lib.install "libh2o.a"
    end

    system "make", "install"

    (etc/"h2o").mkpath
    (var/"h2o").install "examples/doc_root/index.html"
    # Write up a basic example conf for testing.
    (buildpath/"brew/h2o.conf").write conf_example
    (etc/"h2o").install buildpath/"brew/h2o.conf"
  end

  # This is simplified from examples/h2o/h2o.conf upstream.
  def conf_example; <<-EOS.undent
    listen: 8080
    hosts:
      "127.0.0.1.xip.io:8080":
        paths:
          /:
            file.dir: #{var}/h2o/
    EOS
  end

  def caveats; <<-EOS.undent
    A basic example configuration file has been placed in #{etc}/h2o.
    You can find fuller, unmodified examples here:
      https://github.com/h2o/h2o/tree/master/examples/h2o
    EOS
  end

  plist_options :manual => "h2o"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/h2o</string>
            <string>-c</string>
            <string>#{etc}/h2o/h2o.conf</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/h2o -c #{etc}/h2o/h2o.conf"
    end
    sleep 2

    begin
      assert_match "Welcome to H2O", shell_output("curl localhost:8080")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
