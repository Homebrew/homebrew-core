class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-3.6.3/mbedtls-3.6.3.tar.bz2"
  sha256 "64cd73842cdc05e101172f7b437c65e7312e476206e1dbfd644433d11bc56327"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d595b50d6404bb6b941f8f3ddc61cee7fe17a669518b5b756b801aae462af4ec"
    sha256 cellar: :any,                 arm64_sonoma:  "d77d2d06fb3bac8feb447ae1d7d011c37a330a3045eb8c9e07db4bc91c8a79d3"
    sha256 cellar: :any,                 arm64_ventura: "bcd4e4824bcf9ba6e43e9c9e87898f9f39025a735758363a1c03066949857915"
    sha256 cellar: :any,                 sonoma:        "f491400c71a84da4b071bab8aab100be7758c720275f2a6d998e9fa79d5ee4c5"
    sha256 cellar: :any,                 ventura:       "2b167d31cac564ab7d677ed7ba56516a1e6978b39b0a866011afd64a80b80f13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a136b77e4044c460b3479189cabc01d911be9c76e24ec0862ece0131c234d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0ccfd6ef827e572504fa60630a3644215357415ab86dbd21075a4ac95b9b288"
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
