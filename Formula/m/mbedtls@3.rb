class MbedtlsAT3 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://www.trustedfirmware.org/projects/mbed-tls/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-3.6.8/mbedtls-3.6.8.tar.bz2"
  sha256 "bc54b818e87f49c0b3281dd85d24adaede0e63b4e822e3fbd49c005a38b9595b"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])v?(3(?:\.\d+)+)/i)
  end

  bottle do
    manifest_sha256 "6920c82d521e75e3eec45a12a4245ef5fa5d74b4fe28d1054d3aa5d72125f3c7"
    sha256 cellar: :any, arm64_golden_gate: "fd87eb9ce5612a9510d85130b036d8c2b34798d3128f53d992702c2f8276e5f5"
    sha256 cellar: :any, arm64_tahoe:       "962810743b805cd8ddadc42b8e3c202463d521557a23b7ea972fa9ee2375989f"
    sha256 cellar: :any, arm64_sequoia:     "4f12bfd22f62f27d11001294032c6e5fc6fa0ff4e2709c8bee29680765ffe787"
    sha256 cellar: :any, arm64_linux:       "43a259f6d0dad1e677718e88b5a53e96f254a7bb3a9263890f368020e6098157"
    sha256 cellar: :any, x86_64_linux:      "b9d85d0e42808636ae73d62a8a3245e9b97ebc4dcc6391b5a9a53bad3d34f327"
  end

  keg_only :versioned_formula

  # mbedtls-3.6 maintained until March 2027
  # Ref: https://github.com/Mbed-TLS/mbedtls/blob/development/BRANCHES.md#current-branches
  deprecate! date: "2027-03-31", because: :unsupported

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  deny_network_access!

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
