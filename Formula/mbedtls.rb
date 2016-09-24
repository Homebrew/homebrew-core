class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  head "https://github.com/ARMmbed/mbedtls.git", :branch => "development"
  revision 1

  stable do
    url "https://tls.mbed.org/download/mbedtls-2.3.0-apache.tgz"
    sha256 "590734c8bc8b3ac48e9123d44bf03562e91f8dce0d1ac2615c318c077f3215b2"

    # https://github.com/ARMmbed/mbedtls/issues/522
    # They are commits already applied to the upstream.
    patch do
      url "https://github.com/ARMmbed/mbedtls/commit/7247f99b3e068a2b90b7776a2cdd438fddb7a38b.patch"
      sha256 "071830f9b1870ed319fcc65e34ce6d6f9b3476e81f0a204d474635e59ac08687"
    end
    patch do
      url "https://github.com/ARMmbed/mbedtls/commit/b5b6af2663fdb7f57c30494607bade90810f6844.patch"
      sha256 "859ffed5d6e4dfb386c0ee3b9f00efa904d0ee8977272def4bd787e1c9efda82"
    end
    patch do
      url "https://github.com/ARMmbed/mbedtls/commit/b92834324f29768a5bf39c58c674c5f3c09b6763.patch"
      sha256 "f48b42e10ed0462945391ac2c7eb737ed39d377d91960baeaf91fe1325b38c96"
    end
    patch do
      url "https://github.com/ARMmbed/mbedtls/commit/23e9778684ba734dbfba1445e145b04dd6b59e76.patch"
      sha256 "5f642020d7706660778a14547425c5cb5a8c99b56b92ed46514b7a43823487b7"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "79bffe06f7f166c3b809357f7d3bc886e8c94d003d30145564db875e911b1ff4" => :sierra
    sha256 "56b22d0573e5f5c3d741f3474ce244c0c6b2ed090191510960df7e0f26fc108c" => :el_capitan
    sha256 "0a93583a7e6e0d8f88329af3f284a37d7c388a9d0daae158f60125b67f36b234" => :yosemite
    sha256 "187ff5694bdcec466cab8bd88b516d61e9d5b742a53214946dd534083738e300" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # disable support for SSL 3.0
      s.gsub! "#define MBEDTLS_SSL_PROTO_SSL3", "//#define MBEDTLS_SSL_PROTO_SSL3"
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-DUSE_SHARED_MBEDTLS_LIBRARY=On", *std_cmake_args
    system "make"
    system "make", "install"

    # Why does Mbedtls ship with a "Hello World" executable. Let's remove that.
    rm_f "#{bin}/hello"
    # Rename benchmark & selftest, which are awfully generic names.
    mv bin/"benchmark", bin/"mbedtls-benchmark"
    mv bin/"selftest", bin/"mbedtls-selftest"
    # Demonstration files shouldn't be in the main bin
    libexec.install "#{bin}/mpi_demo"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Don't remove the space between the checksum and filename. It will break.
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249  testfile.txt"
    assert_equal expected_checksum, shell_output("#{bin}/generic_sum SHA256 testfile.txt").strip
  end
end
