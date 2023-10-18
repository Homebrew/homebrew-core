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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "74a6aeafe024b9e8adff110b0db2fb1222118f1f9dec3750d078454ede5b1d00"
    sha256 cellar: :any,                 arm64_ventura:  "6fa84ddefb5b288640e435f4acfd743c49506ec7817809ad8e25c96e4b6a91a0"
    sha256 cellar: :any,                 arm64_monterey: "df053aeb5748a8f92c03f7bf316f487582dfc96ee93eb3b65408aad7fee08796"
    sha256 cellar: :any,                 sonoma:         "513873323db8063a7ff788e3ef1aad64b5e3adab81304aef49cb0ae35325aae9"
    sha256 cellar: :any,                 ventura:        "fcf0d128cd9c0063f8c22ce2817dcf7be6c8b0c5ddd4d2544a8b54a90e6d6d66"
    sha256 cellar: :any,                 monterey:       "e7aeb3b1608da64173278f1f07ad64622fff4def27d7cf828062bc8cb8023427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "291c847c785254fa3f4c08bce04469a2f3582df9bfe8bf5d43e517979f99065c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

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
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
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
