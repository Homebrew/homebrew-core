class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.9.0-apache.tgz"
  sha256 "a06a9b43e583b7e6707becfeeb13d88ed00f25fee31a5386cb3a3014c454bad8"
  head "https://github.com/ARMmbed/mbedtls.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "98fb9b3cf215b492bb1fd5d527c056312fee8a488ca7a8903a2619f341a899fe" => :high_sierra
    sha256 "db6e4c54a2df6fd2011b2e717ac0c9a125af24023eb987834be52aa635dc9cc5" => :sierra
    sha256 "7d357052612e57e06d75818ff1ef5c919ac4999542ba24091b71af8f0d946caa" => :el_capitan
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
