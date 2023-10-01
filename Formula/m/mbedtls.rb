class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-3.4.1.tar.gz"
  sha256 "7444c4752bd668f00741b16ec9e4f32fb707979278c9c64b4a905b209595f406"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "400b353f515a2958e0406e7fc1f6e8ddb9d53f652f9af7690551eadae150c4e4"
    sha256 cellar: :any,                 arm64_ventura:  "ea1d7bb96f8bb6a874bd9260b715d0c16df55b00eb0910d05df032e621f7fe3e"
    sha256 cellar: :any,                 arm64_monterey: "6934397c0eb3d676cd4a439fcd34a51f14579d8e3b5c0f5945926fa4df0114f7"
    sha256 cellar: :any,                 arm64_big_sur:  "1ef2e42c5b259bc99dcf80e04c2d928c83f63d1a99d7f2e3be3fa375445d1a6f"
    sha256 cellar: :any,                 sonoma:         "7680032f48dcbd54bfaa12e9735d7869c4851ed769d28b96a04705e00f07f3c9"
    sha256 cellar: :any,                 ventura:        "f724554642e3b665c612796330aca4cf3632c2f2b894b083718e931234903fd7"
    sha256 cellar: :any,                 monterey:       "dc870596911edb6e72b92e94e3e36bc37b371bbf24b5ab6ce2a9d1c00065bfeb"
    sha256 cellar: :any,                 big_sur:        "202ea925efbc5f82140317f3f1150354dd00f5f67b9b7048118a3cbb307e36d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "733441f2bebd85814e10a00d216f134ba3022bca5253a0f2435e546213b7e8a0"
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
