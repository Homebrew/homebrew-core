class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.2.1-apache.tgz"
  sha256 "6ddd5ca2e7dfb43d2fd750400856246fc1c98344dabf01b1594eb2f9880ef7ce"
  head "https://github.com/ARMmbed/mbedtls.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "20f67e11cae0c356b5c33dac6fb3b9a17a3e62537a826233a8135ca07e62257d" => :el_capitan
    sha256 "cc267afb274b37c6f5edf6b95118e92a98c7f0bb900cf83bd4eb10e3e76672f1" => :yosemite
    sha256 "52b4b8b60e962562ffb165c35f5881f731c21a43cc56110eb9d92abe2ac96bc2" => :mavericks
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

    system "cmake", *std_cmake_args
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
