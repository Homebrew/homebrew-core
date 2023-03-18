class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-3.3.0.tar.gz"
  sha256 "a22ff38512697b9cd8472faa2ea2d35e320657f6d268def3a64765548b81c3ec"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "75fae44abe3175d39a82a1c138459ea33fa6e6b62ef515f14271967a07f3824a"
    sha256 cellar: :any,                 arm64_monterey: "68f6114531bdd17099a5d221920ef82ac358b5678c456f8d167b9405e5b31e70"
    sha256 cellar: :any,                 arm64_big_sur:  "7a1b70f3d34628213b037c908777aca1a67ffb24cda8121abfc1f95cd11396b7"
    sha256 cellar: :any,                 ventura:        "7c0052d3fa0e301750d84e9a7b04a4b1162807f24adca123ada45f20e60d4359"
    sha256 cellar: :any,                 monterey:       "dd2c1c332beceb70c109653b2ce23561bd8d8b3cd057e3c73638847f01e7b6ea"
    sha256 cellar: :any,                 big_sur:        "87e14b2db21d3a1f97c00e9b725d5b6ae29f7a3d3afb72b7f017c7af5d33ce72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7837ee52a3ab9f96358106e9fdd881d753ee82e97312c3b8be667e743708e3ec"
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
