class MbedtlsAT3 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-3.6.6/mbedtls-3.6.6.tar.bz2"
  sha256 "8fb65fae8dcae5840f793c0a334860a411f884cc537ea290ce1c52bb64ca007a"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])v?(3(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a363a40850d5eb49bd11028879d2b312eafb9b7b38fefb5cf089014ae3e428f7"
    sha256 cellar: :any,                 arm64_sequoia: "b3485e10f62304b4b61af65f7b4e0fa9331687b0c74642e50019adf2e7c7ffd2"
    sha256 cellar: :any,                 arm64_sonoma:  "14ce5476ba9ec9c22b163ef50ae17b89500716d1084a1c6d893ccd9935713011"
    sha256 cellar: :any,                 sonoma:        "6dad4026c51512381cab9ac7a82e041a2a1cee120c23b869c97822b45e20daa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a416c0fe1570337994e7ad7c5bbb6e1110c81abac768fc0a8837e60f9ae9426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78735c99e399005253f01a93ed4beab4e30600a749f96c4641309b4a1c5d89d2"
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
