class H2o < Formula
  desc "HTTP server with support for HTTP/1.x and HTTP/2"
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "f8cbc1b530d85ff098f6efc2c3fdbc5e29baffb30614caac59d5c710f7bda201"
  license "MIT"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7052d31aee99253193fa7e7bdbdff7c1c1d838783c5f3bf01eb60303cadfcccb"
    sha256 arm64_sequoia: "7a1fc642567278a8aa2a7d35860b34a5243b5632be0b710601222a70404525bd"
    sha256 arm64_sonoma:  "216fc94308b217f17545983c554f361aa2269a60a32274bc19e3ecb307e00dff"
    sha256 sonoma:        "73890630b88d90aade5f50e9b398dabd7d32721d04048d5be9ad4a5c086a5251"
    sha256 arm64_linux:   "a8f570c2dc1dec9d24cd097b6b2b0c1ebb6d5186e6d7e8937248713a2250531a"
    sha256 x86_64_linux:  "3610f00d45e27f430806f37e64f1038864d821c7cf622b572492f046398b3bc0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    # https://github.com/Homebrew/brew/pull/251
    ENV.delete("SDKROOT")

    args = %W[
      -DWITH_BUNDLED_SSL=OFF
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]

    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    # Build shared library.
    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Build static library.
    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
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
    spawn "#{bin}/h2o -c #{testpath}/h2o.conf"
    sleep 2
    assert_match "Welcome to H2O", shell_output("curl localhost:#{port}")
  end
end
