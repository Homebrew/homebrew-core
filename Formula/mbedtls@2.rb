class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-2.28.1.tar.gz"
  sha256 "82ff5fda18ecbdee9053bdbeed6059c89e487f3024227131657d4c4536735ed1"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development_2.x"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b9683d97e7b975165e30db14429f24dfaa200debedf46e079d3b6746d0a5d1a0"
    sha256 cellar: :any,                 arm64_monterey: "9334ea247c229ad29ed6b0e0c388b1c589c70e7187e3d8ed6bcd051ebceb1291"
    sha256 cellar: :any,                 arm64_big_sur:  "bada695460468813a313ddae30a66888cb830d90e0f542f18508504bd4bedaf2"
    sha256 cellar: :any,                 ventura:        "d540f2eb5697aeedad1fc0a9d700fce533641f7f2022154084b337f4e768cf76"
    sha256 cellar: :any,                 monterey:       "a135ca31c4f80a80fcc42eb127e9538860b561ff8c62abbe4f70211be2ff8d48"
    sha256 cellar: :any,                 big_sur:        "b335ec7c23a52d9aac74d184df4cb981ea930d955c4b57ce500591775dbf05b2"
    sha256 cellar: :any,                 catalina:       "b93d06f753ca54aa84d22357c5cb682ad927769a859781cfbab239f68631ab7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27e1b4369e86f86e399aee3b6bc24de82cdf6db688618d2e8da9189c9f2c2822"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.10")}",
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
