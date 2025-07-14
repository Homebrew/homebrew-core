class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-3.6.4/mbedtls-3.6.4.tar.bz2"
  sha256 "ec35b18a6c593cf98c3e30db8b98ff93e8940a8c4e690e66b41dfc011d678110"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d8f7928cbeb8380b3d39591956c884a2353f411f2537654db8e37c6d4cd771d"
    sha256 cellar: :any,                 arm64_sonoma:  "b52142a9212d2ba22c583d0d490f8f60c668265061aecec8083339cffcc605eb"
    sha256 cellar: :any,                 arm64_ventura: "6e20b77f9c4d0db9e5b7c8bf8c0e5cc4ccb82e36686d879cf1f2731101adf17a"
    sha256 cellar: :any,                 sonoma:        "d6868d898949c78b4cbb9ea8c2bac0b858102344e84d516dd8759a0905019b02"
    sha256 cellar: :any,                 ventura:       "f0eb7a4df4d1a64e30d293544089706ca5ce4ff23acd32246fc101cf27e39b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfdcc6a8f16a79601d3aa0b24a8e3722144d92b938c3ebd637b77ab7c72f44e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf0c211ef718cfc840979ee95ddce71e548e86733017cdec1e0555aac2df6ad5"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build

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
                    "-DPython3_EXECUTABLE=#{which("python3.13")}",
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
