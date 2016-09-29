class H2o < Formula
  desc "HTTP server with support for HTTP/1.x and HTTP/2"
  homepage "https://github.com/h2o/h2o/"

  stable do
    url "https://github.com/h2o/h2o/archive/v2.0.4.tar.gz"
    sha256 "c0efa18f0ffb0f68ee4b60a6ed1feb54c770458c59e48baa2d9d0906ef9c68c0"

    depends_on "openssl" => :recommended
  end

  bottle do
    sha256 "e9029c054ed3a8672e38a8114ced58c9d3e21e70fb73a61d452746678446f4cf" => :sierra
    sha256 "b2f4bf96916db1a713ce4acb2c2e4c94aaa085d3c7572004ee55d91fd7bdd39d" => :el_capitan
    sha256 "220ada282b02f463212dee500e0fbb7bc2e70dcb0bf2c5c88ecc43f34583d563" => :yosemite
    sha256 "7471f50113eb406db5c101860630829e3d4439001ad85de88a5c8db062b112b1" => :mavericks
  end

  devel do
    url "https://github.com/h2o/h2o/archive/v2.1.0-beta3.tar.gz"
    version "2.1.0-beta3"
    sha256 "e85aa794b1d1dd074f44e1a2df6afee61175b443f8fa6413a47033c179485d2a"

    depends_on "openssl@1.1" => :recommended
  end

  option "with-libuv", "Build the H2O library in addition to the executable"
  option "without-mruby", "Don't build the bundled statically-linked mruby"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libressl" => :optional
  depends_on "libuv" => :optional
  depends_on "wslay" => :optional

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    # https://github.com/Homebrew/brew/pull/251
    ENV.delete("SDKROOT")

    openssl = build.stable? ? Formula["openssl"] : Formula["openssl@1.1"]
    if build.with?("libressl") && build.with?(openssl)
      odie "--without-#{openssl} must be passed when building --with-libressl"
    end

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
