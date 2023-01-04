class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-2.28.2.tar.gz"
  sha256 "1db6d4196178fa9f8264bef5940611cd9febcd5d54ec05f52f1e8400f792b5a4"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development_2.x"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11bdbdfac1856bac179d00e3d4f817b56eb9dbf6226304083aba407e50a0132f"
    sha256 cellar: :any,                 arm64_monterey: "9929799ce303833ce06c3ca5f53baab4d2be56f670b4bf20f605a1a50fed604f"
    sha256 cellar: :any,                 arm64_big_sur:  "169614a9cdba21b3a6e87a55c3b4269fb613c5fdbd70706ffb15347f3a9c9da0"
    sha256 cellar: :any,                 ventura:        "f7bb83a0f5b5345bd83f70d7b1575e1b8da02029dabf80ccd628c133c2ef9b4e"
    sha256 cellar: :any,                 monterey:       "e2e7ff9ad34ef5d08a2579a755f9e5e205ba65e83f0275b6bc08d6e08d0b802f"
    sha256 cellar: :any,                 big_sur:        "02461f5f2aa5cac6e4eb749ab88d56505026fbd3c84c15d834851e291bfd809c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec992c648e1e0e3d1fd3b08acce0b82a451a5f09464c0a7852a6417c587da18"
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
