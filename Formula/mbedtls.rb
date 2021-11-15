class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/ARMmbed/mbedtls/archive/mbedtls-3.0.0.tar.gz"
  sha256 "377d376919be19f07c7e7adeeded088a525be40353f6d938a78e4f986bce2ae0"
  license "Apache-2.0"
  head "https://github.com/ARMmbed/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "55d871e2222b5ee213c23481c6a5add8ed4f9e4328e475610653e8d3ec852686"
    sha256 cellar: :any,                 arm64_big_sur:  "b5b96186a91ef95346dbc7b3ecdcc5e9b063e16ca2a8cc5901af228d5f16a909"
    sha256 cellar: :any,                 monterey:       "a236edea069a0222a627813c4912fb7ad78cc71294bb03c34716a550acf2f0ac"
    sha256 cellar: :any,                 big_sur:        "7dcd77c125f32c7285190070bbe933156f1e7c667a29bf673e851ed6ebb64064"
    sha256 cellar: :any,                 catalina:       "3d1334aadcb984922eda762c5fcf607bec7d3dc7a095077cb46b6611a86fcad3"
    sha256 cellar: :any,                 mojave:         "4966455e9853dae759dd194e881ca075049490dfc0a05e9d4b64abe59d7a4392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffed081a0cd5a843dfacaa572e9f3f88bbc4b06f1917d705dc4b180dc179a220"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    inreplace "include/mbedtls/mbedtls_config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    # We run CTest because this is a crypto library. Running tests in parallel causes failures.
    # https://github.com/ARMmbed/mbedtls/issues/4980
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
