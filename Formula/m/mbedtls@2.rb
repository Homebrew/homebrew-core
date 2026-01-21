class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/mbedtls-2.28.10.tar.gz"
  sha256 "c785ddf2ad66976ab429c36dffd4a021491e40f04fe493cfc39d6ed9153bc246"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5464397f0b136439069dd2c763b20192d423cd5c1c2f0771b031656a660e75a8"
    sha256 cellar: :any,                 arm64_sequoia: "1ac6bd9c970e98200758af383b9e8295387bd7b4c247dcdcb16cb05521b39607"
    sha256 cellar: :any,                 arm64_sonoma:  "194e03a15d26c9c866962875b2d1e5ccedab9e10f7ad9d60e01a155c88fdc2b6"
    sha256 cellar: :any,                 arm64_ventura: "353399bc51df1d729cdcf045ad7da4f268acbc4f562eb9ae9fb18e12658ee9a1"
    sha256 cellar: :any,                 sonoma:        "2269cb5ed16600a247a38499b79c7418c9af39087c0d0e0775b045e87cd11f7c"
    sha256 cellar: :any,                 ventura:       "b73d53ebca5b7ca6781171b446c2120d01ca0979c3d510f51026de739650a470"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "839293c23e53ef5576077ab17ca04d66e5ea23dc70b6da9ce5f31672bc4d5b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ae36df2af07705fc3817ecc1374a68eb2a21dac30b77e1e1b46970f4ab8e8a8"
  end

  keg_only :versioned_formula

  # mbedtls-2.28 maintained until the end of 2024
  # Ref: https://github.com/Mbed-TLS/mbedtls/blob/development/BRANCHES.md#current-branches
  deprecate! date: "2025-03-31", because: :unsupported
  disable! date: "2026-03-31", because: :unsupported

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    args = %W[
      -DUSE_SHARED_MBEDTLS_LIBRARY=On
      -DPython3_EXECUTABLE=#{which("python3.12")}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    # Workaround for CMake 4 compatibility
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
