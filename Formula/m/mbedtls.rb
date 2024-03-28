class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/v3.6.0/mbedtls-3.6.0.tar.bz2"
  sha256 "3ecf94fcfdaacafb757786a01b7538a61750ebd85c4b024f56ff8ba1490fcd38"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a0f2bf18e23d85b1d4a0d1497724f030e1e4650bbdff37bc92c594802935e1d5"
    sha256 cellar: :any,                 arm64_ventura:  "d05f7ff6a61ba307a8d5172cb5af2ef51af806ee4151c1718d59f0e8b3a26848"
    sha256 cellar: :any,                 arm64_monterey: "f389f1f98332beb78f959ef2be9d6374770e2942e7e9d56365a58158df303ab3"
    sha256 cellar: :any,                 sonoma:         "7457d173b49c461e0ecd13413be9b8946e5e112c378dd524e73b6b7488d4a472"
    sha256 cellar: :any,                 ventura:        "bd2e15b043e7798127225ef4a85c06b8a5f56be32ef7ae33556d83baf3b64e4e"
    sha256 cellar: :any,                 monterey:       "12297925546cdbc74c1d52216e1f269a954f29c982c5544e04b90c07b85b5113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d07bf65d611943014c681526111c9ff30e2151ed3c0cbdd21c2c3078be4c0f3"
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
