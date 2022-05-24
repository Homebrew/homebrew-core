class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-2.28.0.tar.gz"
  sha256 "f644248f23cf04315cf9bb58d88c4c9471c16ca0533ecf33f86fb7749a3e5fa6"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development_2.x"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "480c3df5089fb6a963a13b8ccb14d4d81ed3ecced160a69072f93ed65114c814"
    sha256 cellar: :any,                 arm64_big_sur:  "71d898a6da3baec04462fc74d637d43a3b4515fe82f6c7822ee46a8cba0175c6"
    sha256 cellar: :any,                 monterey:       "fa7d7034bb61d649726a9d9ae3451ab8ac703f47f16d765b821ea77c67cce54d"
    sha256 cellar: :any,                 big_sur:        "cf925beaf286bae475950b3aab234a7f4f192ae2ab7b5c998002153a3b24aa87"
    sha256 cellar: :any,                 catalina:       "d19f714bfccd87cc8dc6c1536bad7d581ed74e4c1009db9a80f645f01ed65256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "283c9006292ec1fef627a3366aa818b67ebeb7d1086f575f4d50f539e5f19c1c"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3",
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
