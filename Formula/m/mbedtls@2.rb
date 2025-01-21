class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/mbedtls-2.28.9.tar.gz"
  sha256 "53231b898f908dde38879bf27a29ddf670dee252dec37681f2c1f83588c0c40e"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "mbedtls-2.28"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b5532ff937e7862586967ce962e17f9d6e4acdc85b7ab16f2daf3f6b7af0acf0"
    sha256 cellar: :any,                 arm64_sonoma:   "5cc14e7a9ce31d594a907663011aeae35e74c0ef2044cc9e9e2e974249d2d5a6"
    sha256 cellar: :any,                 arm64_ventura:  "9f38c7b850b6d6455283d68a663236d4960ab99c2ef51aee2f4338bbeb3faa56"
    sha256 cellar: :any,                 arm64_monterey: "c482fbc260e3fd3a30aebb0c9a4281608f070241e52dd1521160298270f72796"
    sha256 cellar: :any,                 sonoma:         "239f56266e9c4973052fcd4649503a41b353bd533fe7ee10b8ed7154ac94f93a"
    sha256 cellar: :any,                 ventura:        "1dc26fe3274a6fe6d464801ec39fbc5aa6d54b8f9ea6a8709c53f032a13ce156"
    sha256 cellar: :any,                 monterey:       "c007e6e7cd5cbeb33de3004050953cb2a72b69d6d85e1715660b058e62db9d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04f2d19b6fc2a76e6675df52e0a052a8d204ac659d68157812b514ca949f3568"
  end

  keg_only :versioned_formula

  # mbedtls-2.28 maintained until the end of 2024
  # Ref: https://github.com/Mbed-TLS/mbedtls/blob/development/BRANCHES.md#current-branches
  deprecate! date: "2025-03-31", because: :unsupported

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
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
