class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-3.4.0.tar.gz"
  sha256 "a5dac98592b1ac2232de0aed8f4ee62dffaa99e843e6f41dca2958095c737afd"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cceffba500502626f1dccbdc121e26a16595130d85299227254cf8ed52a73ccf"
    sha256 cellar: :any,                 arm64_monterey: "0c692684c712798cb6f27ddaecf1b8e035071be7d02dc1d12e5d117c11db93d0"
    sha256 cellar: :any,                 arm64_big_sur:  "367067a0ee05d791efb5fa42e0a5f5f7762e2891e9bb7ad42aa404ee9c37f5ec"
    sha256 cellar: :any,                 ventura:        "6be8fe0a38baec5e18a59eb871027dbf445eb3efdb458ed3962df73de3bd8056"
    sha256 cellar: :any,                 monterey:       "20052ab98c30a9e05f39baa991e192b7139d8de0b8e4f813d601411935e21fae"
    sha256 cellar: :any,                 big_sur:        "82d92f3edefc4320a5d032672f19b407bd0c3bc634a00cd6e2e637702423f4a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e1d4d8fc02d527bcb84c48688baed7840b127b43db79d4c4399829957328337"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    inreplace "include/mbedtls/mbedtls_config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
      # enable DTLS-SRTP extension
      s.gsub! "//#define MBEDTLS_SSL_DTLS_SRTP", "#define MBEDTLS_SSL_DTLS_SRTP"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.11")}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DGEN_FILES=OFF",
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
