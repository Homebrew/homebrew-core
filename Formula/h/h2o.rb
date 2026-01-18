class H2o < Formula
  desc "HTTP server with support for HTTP/1.x and HTTP/2"
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "f8cbc1b530d85ff098f6efc2c3fdbc5e29baffb30614caac59d5c710f7bda201"
  license "MIT"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "32c8d30fc271c3dafe6d2a2a6e0883adf6201cdefa4c3dfd105ad051ce5ae2b3"
    sha256 arm64_sequoia:  "c54b0d937a91c61b234753347dd756cb2a26dcb3b7f1aa37252b55fb9ee065ae"
    sha256 arm64_sonoma:   "02473fe011f04525a6e4fd604baa839c43988ca3fc96396774d96200e79daf87"
    sha256 arm64_ventura:  "1227fcbf6a078a4448106c6e60af24e1bb271823a50590bf201e4887784b8edb"
    sha256 arm64_monterey: "df4235fa62ee97877317730f405c523eb091f32ec9bf3ad433b9a72596a60fe3"
    sha256 arm64_big_sur:  "08434131f8e46623e330dbfe07d4d2010cd9c55d28b308c04a93efb6a5cfb4a2"
    sha256 sonoma:         "65f63aaef6dbb1ea867afc03d5ea6766dbf317cc572787ec5d30c9fa65a0ebbd"
    sha256 ventura:        "4d046c5d98b9a75b8f53bdc068f2246c7c1958e8f4863ed2f8f2610ee6674934"
    sha256 monterey:       "bd75d169a42961123cc4791aa219572cf9181185ae0cb8679a3a10e7705a688c"
    sha256 big_sur:        "d54fbb44713fa39e3172e0e70a224fbd67e7657357c8179a2c257b510a9bf167"
    sha256 arm64_linux:    "a7aafba0cec8e259b00f5a12d5a65ff12652803f1d2638c8d7c8697b44d02796"
    sha256 x86_64_linux:   "ec3f7d26e8df24768cf2953db461dcff9a5713bb79a23c553cd30016b6a7fba6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
