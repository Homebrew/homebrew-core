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
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "f7ba34fc61d3246cd0613922df69f2607741b528e3c0ddfd07250c366a1b8352"
    sha256 cellar: :any,                 arm64_monterey: "a74c0e95e23ee4ba92efdd6639575b57513313b22dd739b5f5bbc0a1028cfdad"
    sha256 cellar: :any,                 arm64_big_sur:  "700bfca8dc0c813e5ada099ce4447070f8b3b870d3ffae7a551873d9edde3e71"
    sha256 cellar: :any,                 ventura:        "87733b552725daa9d248cd43f370dbd306d628f107915040ab6b9404cf76b442"
    sha256 cellar: :any,                 monterey:       "1d22fe8643320336647d3400912d782bbb73b0cd95d11f233dbb47a343b23eb6"
    sha256 cellar: :any,                 big_sur:        "5de73a9242b98781def686f73f1163fa801066194927f578b1c9a5f584306484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa8801cace5b342aa221a9c0c98e50e51db0273731072ff1b647946c82df0e31"
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
