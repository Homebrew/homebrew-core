class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-2.28.5.tar.gz"
  sha256 "dbd42a11c26143aa8de1c07fd6ec6765395e86b06f583f051cfa60e8f0b23125"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "mbedtls-2.28"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "dc273264beb39ca97922e68ca070166bae3eb99d03d8d24a4924ab581b82b50b"
    sha256 cellar: :any,                 arm64_ventura:  "28786e30c8173e0b89ac4290791d507a0f78b7a72aa1b2fb939d7d34dc363bd4"
    sha256 cellar: :any,                 arm64_monterey: "1194cfe9e7b7fb62a445556d588e5f1a67c84e1531cad88275ad482674c22571"
    sha256 cellar: :any,                 sonoma:         "c2c0ad96b6df8d37602118ca54f16e0bd66e4489df561048d84174b551aa7909"
    sha256 cellar: :any,                 ventura:        "2802ee278bdb74ff8ec0bbc38c09167308c6419adaa167885214e7e8b62c5181"
    sha256 cellar: :any,                 monterey:       "1186098c57c834638896d2cbea217aecc2cfb46212de9ad9095a3e2d96baf2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99b1a85099e780f28bebb27bb707f48442166adf1910725abe75eb64d771bb48"
  end

  keg_only :versioned_formula

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
