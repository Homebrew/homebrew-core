class H2o < Formula
  desc "HTTP server with support for HTTP/1.x and HTTP/2"
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/v2.2.5.tar.gz"
  sha256 "eafb40aa2d93b3de1af472bb046c17b2335c3e5a894462310e1822e126c97d24"

  bottle do
    sha256 "0810858740e6e248344e472d6b2ae7e78d831542da78f72a7e7eb2c870f83f80" => :mojave
    sha256 "8aa6209db25f8ae5bd584ddda2d189245a927a060ddc50d24a4273f26f384ee7" => :high_sierra
    sha256 "108be952a5875616441024a213e34eef7799d9e9cd16ff13d3fa44187c40384b" => :sierra
    sha256 "828eb276e4173b6c89fe4cc36bc8e253960f678dcebf36e1f9424087582f085b" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  uses_from_macos "zlib"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    # https://github.com/Homebrew/brew/pull/251
    ENV.delete("SDKROOT")

    system "cmake", *std_cmake_args,
                    "-DWITH_BUNDLED_SSL=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
    system "make", "install"

    (etc/"h2o").mkpath
    (var/"h2o").install "examples/doc_root/index.html"
    # Write up a basic example conf for testing.
    (buildpath/"brew/h2o.conf").write conf_example
    (etc/"h2o").install buildpath/"brew/h2o.conf"
    pkgshare.install "examples"
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

    You can find fuller, unmodified examples in #{opt_pkgshare}/examples.
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
