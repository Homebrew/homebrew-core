class H2o < Formula
  desc "HTTP server with support for HTTP/1.x and HTTP/2"
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/v2.2.6.tar.gz"
  sha256 "f8cbc1b530d85ff098f6efc2c3fdbc5e29baffb30614caac59d5c710f7bda201"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_ventura:  "c03e1941f5138d1601fb16511c1a709086fe70d20b49b031e93c93cc581239f2"
    sha256 arm64_monterey: "2dbad9aa8ba17951616a2b93dfc52b707ab0e7515cb9ec6efa43fc260edd1786"
    sha256 arm64_big_sur:  "c58c917d16ff1fcdde97c6bbf8c2bf5337120dc6c8a233f23be20096e9546af8"
    sha256 ventura:        "ad6c689ce2b91644f70266d392fe570b5aef350b41eea2c33117af4289adab9f"
    sha256 monterey:       "f4d194b0192c88a258becd40eff437c36991fad0013afdec891e4c8fbcb5edba"
    sha256 big_sur:        "63efa37625758c8df46dfe344b8010d8117b687d62cb2ee9ed0973d609116d85"
    sha256 catalina:       "a60e3af7351adeebc4b93d0ae14229890734398c1b65b4198e4d6263a16d918d"
    sha256 x86_64_linux:   "7c1a3647fc3cbe91331bc2d320b405fddeb4228a5685e6cadd499e326abd8473"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    # https://github.com/Homebrew/brew/pull/251
    ENV.delete("SDKROOT")

    args = std_cmake_args + %W[
      -DWITH_BUNDLED_SSL=OFF
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
    ]

    # Build shared library.
    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Build static library.
    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/libh2o-evloop.a"

    (etc/"h2o").mkpath
    (var/"h2o").install "examples/doc_root/index.html"
    # Write up a basic example conf for testing.
    (buildpath/"brew/h2o.conf").write conf_example
    (etc/"h2o").install buildpath/"brew/h2o.conf"
    pkgshare.install "examples"
  end

  # This is simplified from examples/h2o/h2o.conf upstream.
  def conf_example(port = 8080)
    <<~EOS
      listen: #{port}
      hosts:
        "127.0.0.1.xip.io:#{port}":
          paths:
            /:
              file.dir: #{var}/h2o/
    EOS
  end

  def caveats
    <<~EOS
      A basic example configuration file has been placed in #{etc}/h2o.

      You can find fuller, unmodified examples in #{opt_pkgshare}/examples.
    EOS
  end

  service do
    run [opt_bin/"h2o", "-c", etc/"h2o/h2o.conf"]
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"h2o.conf").write conf_example(port)
    fork do
      exec "#{bin}/h2o -c #{testpath}/h2o.conf"
    end
    sleep 2

    assert_match "Welcome to H2O", shell_output("curl localhost:#{port}")
  end
end
