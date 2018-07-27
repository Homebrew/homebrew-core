class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.12.0-apache.tgz"
  sha256 "a2bed048f41a19ec7b4dd2e96649145bbd68a6955c3b51aeb7ccbf8908c3ce97"
  head "https://github.com/ARMmbed/mbedtls.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "12bbbd664de6816e0a45731b17556b32c2a82b8f397623ff76380cb2a6812a44" => :high_sierra
    sha256 "863d561c872aef7c1f4a329eb9caa64a5a33cfce2f6fe9fa07d876f5b6a26d40" => :sierra
    sha256 "1e0a85fd3ba9ee9e8c252883baa87ccc2c6536ae4a54c1169645c2c0a059c57b" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-DUSE_SHARED_MBEDTLS_LIBRARY=On", *std_cmake_args
    system "make"
    system "make", "install"

    # Why does Mbedtls ship with a "Hello World" executable. Let's remove that.
    rm_f bin/"hello"
    # Rename benchmark & selftest, which are awfully generic names.
    mv bin/"benchmark", bin/"mbedtls-benchmark"
    mv bin/"selftest", bin/"mbedtls-selftest"
    # Demonstration files shouldn't be in the main bin
    libexec.install bin/"mpi_demo"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Don't remove the space between the checksum and filename. It will break.
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249  testfile.txt"
    assert_equal expected_checksum, shell_output("#{bin}/generic_sum SHA256 testfile.txt").strip
  end
end
