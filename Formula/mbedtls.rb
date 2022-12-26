class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-3.3.0.tar.gz"
  sha256 "a22ff38512697b9cd8472faa2ea2d35e320657f6d268def3a64765548b81c3ec"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34339731ff914e54f43da25f27009496cffb6c79f54616d77efbbd73203d75fa"
    sha256 cellar: :any,                 arm64_monterey: "f2723318e1b708f85d899274beb09014605d433bc13ad1614c5f3dcd2e44d315"
    sha256 cellar: :any,                 arm64_big_sur:  "164a8fb70c2e5033ef82692cffdc7f19fbd7ddcc03c04bbb70bc8dc63759389e"
    sha256 cellar: :any,                 ventura:        "1e16bf397c8cf8b2b97e0a9bfe528faed102bb3b0c0244875ec567c1c004db1d"
    sha256 cellar: :any,                 monterey:       "ea763278788d0f2327259335266f4a7acb8855b58c7cce2c5674655440dcfb64"
    sha256 cellar: :any,                 big_sur:        "72c46972acb5b431cbcca78089e3dc06a593c774c5195b9ae408b821d71410cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e69e5ac71eb61eed22a88d193c757946c0acf568aebb27f5eea27ad3720b73de"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    inreplace "include/mbedtls/mbedtls_config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
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
