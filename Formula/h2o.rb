class H2o < Formula
  desc "HTTP server with support for HTTP/1.x and HTTP/2"
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/v2.2.6.tar.gz"
  sha256 "f8cbc1b530d85ff098f6efc2c3fdbc5e29baffb30614caac59d5c710f7bda201"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_monterey: "961401a86df0e09866bb9f424393642bd1df3dd60340fbbc71f3475f98a5f06f"
    sha256 arm64_big_sur:  "235585aa8d60bdf07e3589282ae5704a7b417312e701a8774a12fbf407642aa1"
    sha256 monterey:       "a33e81de4de46a46f3846280b32ec258e23bcec22d8c75518d1b258c993fbde5"
    sha256 big_sur:        "44af35463fd8c70fa3cd4014dd8ec92c93e33b96a3dde07aa5e8c532f4ba15d3"
    sha256 catalina:       "c3a59a760f51a19c8a6e946a49d7f689b81bef8f80d9157c9be5af628b6b2a1a"
    sha256 mojave:         "7aa27f5811da60d7c51e4124ed8f54f102496c5e29585007fb2fe9cfee646bbe"
    sha256 x86_64_linux:   "b33805c89af5cff42fd08df6fcd263a63721cbc04daf115e879fb0dc680aaa4f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    # https://github.com/Homebrew/brew/pull/251
    ENV.delete("SDKROOT")

    system "cmake", *std_cmake_args,
                    "-DWITH_BUNDLED_SSL=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"

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
