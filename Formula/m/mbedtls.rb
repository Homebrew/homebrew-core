class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-3.5.0.tar.gz"
  sha256 "02311fc8bd032d89ff9aee535dddb55458108dc0d4c5280638fc611aea7c5e4a"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "506d0321ec8bd0756c69e801086992ae4b7ee47c875a4376e52c88351c2bedbf"
    sha256 cellar: :any,                 arm64_ventura:  "1d2088183f2cf0d2768694984eca8c1d20fd0bedac8a4e845a85188a57569036"
    sha256 cellar: :any,                 arm64_monterey: "b7de57848f580dabbb639a7f138cd1d8e37da997ba3fd9f3d92ac56c7da49816"
    sha256 cellar: :any,                 sonoma:         "5bb4e0398a95122ed3f44ce9c6221d8556e5a854021031ce88933a00b791bbc9"
    sha256 cellar: :any,                 ventura:        "4e64c87bd56645bf8b37c1c212063fe3ace97a4dab432a3318233df18b6aa7a2"
    sha256 cellar: :any,                 monterey:       "f053675654e75fb7d2fb7ce76658d09110bda318904dfe244c9bcf006abd076c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "593e10196edb674ba4fc0fd7d9f0793f7a2143cde08cedcb3d327d0c37c824f1"
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
