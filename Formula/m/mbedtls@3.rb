class MbedtlsAT3 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-3.6.5/mbedtls-3.6.5.tar.bz2"
  sha256 "4a11f1777bb95bf4ad96721cac945a26e04bf19f57d905f241fe77ebeddf46d8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])v?(3(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d3a58038145d2683f3b6700a281487a437ece4e73c6cc6fcd8efbd07e2e2c045"
    sha256 cellar: :any,                 arm64_sequoia: "024755c986d3514f84e462ea08a94bf677ede572dc03340fab817ddeb6787836"
    sha256 cellar: :any,                 arm64_sonoma:  "8133322a7fe33d6181da0bec7657506e5bd2b196da726e56ea1872628f27ce5a"
    sha256 cellar: :any,                 sonoma:        "713afec227329cb142f271b24ac471a6e1322368ac4e2f2bacf33aeaddc055dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "395307a648d0d72f75a35c84c79b2398618ed7b74d76a0978e64d67857ff4344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b3e45329e73450bb838d8d223798e0d2f23847093dc5ae3a97a66963dbd86e5"
  end

  keg_only :versioned_formula

  # mbedtls-3.6 maintained until March 2027
  # Ref: https://github.com/Mbed-TLS/mbedtls/blob/development/BRANCHES.md#current-branches
  deprecate! date: "2027-03-31", because: :unsupported

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

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
                    "-DPython3_EXECUTABLE=#{which("python3")}",
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
    rm(bin/"hello")
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
