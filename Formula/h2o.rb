class H2o < Formula
  desc "HTTP server with support for HTTP/1.x and HTTP/2"
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/v2.2.4.tar.gz"
  sha256 "ebacf3b15f40958c950e18e79ad5a647f61e989c6dbfdeea858ce943ef5e3cd8"

  bottle do
    sha256 "05e55f9200a569b44094ceafcb11b516391ec6a99c49df6a076584b6239ccc4e" => :high_sierra
    sha256 "6cc8687866d2209cc02b24d4395f1072338c2c51178422dec676687e5f54104c" => :sierra
    sha256 "927ca501a4423e447d3cbdd51123077251deb47adb38c351bbff07a8a537366f" => :el_capitan
  end

  option "with-libuv", "Build the H2O library in addition to the executable"
  option "without-mruby", "Don't build the bundled statically-linked mruby"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
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
  def conf_example; <<~EOS
    listen: 8080
    hosts:
      "127.0.0.1.xip.io:8080":
        paths:
          /:
            file.dir: #{var}/h2o/
    EOS
  end

  def caveats; <<~EOS
    A basic example configuration file has been placed in #{etc}/h2o.
    You can find fuller, unmodified examples here:
      https://github.com/h2o/h2o/tree/master/examples/h2o
    EOS
  end

  plist_options :manual => "h2o"

  def plist; <<~EOS
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
