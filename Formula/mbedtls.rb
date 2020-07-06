class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.16.6-apache.tgz"
  sha256 "66455e23a6190a30142cdc1113f7418158839331a9d8e6b0778631d077281770"
  license "Apache-2.0"
  head "https://github.com/ARMmbed/mbedtls.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "eda862a92461ba28c8b122dca7264bc81e487735de652b7f15a227de3b7eaa86" => :catalina
    sha256 "efb7c341a158a90fce32f24f13d93e0e5b40dbbc6d68f328418f8117005b2b7b" => :mojave
    sha256 "dd6c1d8ca7d4156b9c4ac7f39c2f50cb99ce09a64db37d0b4b0341c93d4def49" => :high_sierra
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
