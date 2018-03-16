class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.7.0-apache.tgz"
  sha256 "aeb66d6cd43aa1c79c145d15845c655627a7fc30d624148aaafbb6c36d7f55ef"
  head "https://github.com/ARMmbed/mbedtls.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "dca503826b9183c68dcdbdf620a2b687b49c18ff18d60f8386c1f15af33bda44" => :high_sierra
    sha256 "ec1d4762f786b3633c4ad8e6443fecb195c9c87fae16275c7232c9c686f3f4ac" => :sierra
    sha256 "2f1daabe90f5a505b8fc145ce5134e4773cb73e017f9edd2ab5bf2b0f169cee0" => :el_capitan
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
