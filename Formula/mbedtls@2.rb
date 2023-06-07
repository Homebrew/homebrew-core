class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-2.28.3.tar.gz"
  sha256 "1a21008fc93e7bdce2cb40a8f2d7c7b4034d9160035382c29cf91af8f96f2cd9"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "mbedtls-2.28"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c073bf6c9bde12361e2e64112a752242da3aacb75a804537247348f5e23ae5b"
    sha256 cellar: :any,                 arm64_monterey: "555f0133c5a0994bae5dbf30d6184151c7b530bf2ac932c90ba46bbc81e9c13d"
    sha256 cellar: :any,                 arm64_big_sur:  "1c9413df42ff481f54128727f45bb88bbe322ebfd42b9224f35817072f053cd3"
    sha256 cellar: :any,                 ventura:        "0d16dc6ebe9c1bb3917eaa31d0700edad557ef2c0239cf37c1be9162412a7908"
    sha256 cellar: :any,                 monterey:       "81d5aacef9264297da9342fd92af0230c9696c1ae332e37fc7b1ac8098ad4830"
    sha256 cellar: :any,                 big_sur:        "43d1f01f88b80a6cbb53bc6e4ac6a02ee29484bc44d4f283457e2f58682a6513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "810fea4245ebcb975c864cf41e1b0aee6c4b69fcd4e4da4a4a7e162bab1ba15f"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.11")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    # We run CTest because this is a crypto library. Running tests in parallel causes failures.
    # https://github.com/Mbed-TLS/mbedtls/issues/4980
    with_env(CC: DevelopmentTools.locate(DevelopmentTools.default_compiler)) do
      system "ctest", "--parallel", "1", "--test-dir", "build", "--rerun-failed", "--output-on-failure"
    end
    system "cmake", "--install", "build"

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
