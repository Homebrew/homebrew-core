class H2o < Formula
  desc "HTTP server with support for HTTP/1.x and HTTP/2"
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/v1.7.3.tar.gz"
  sha256 "546bcde8aa3cf996d161d1e75aaad159d10fca1b3d368c4270f0674e8c78a213"
  head "https://github.com/h2o/h2o.git"

  bottle do
    sha256 "abd2a7f220cd0d5bec3b10b008a13b435256693337622f4cbcaf23217e743f36" => :el_capitan
    sha256 "72650bab63162da29198b01f36f4ff3744b842b58abf53e5496d8f8d6a6397ca" => :yosemite
    sha256 "286cefa976737099c693c46c92f97549fedd7d883dae67e2fb84efe3312d375f" => :mavericks
  end

  option "with-libuv", "Build the H2O library in addition to the executable"
  option "without-mruby", "Don't build the bundled statically-linked mruby"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
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
