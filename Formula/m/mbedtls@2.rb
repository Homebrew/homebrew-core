class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/mbedtls-2.28.8.tar.gz"
  sha256 "98b91415d86311b9c08f383906f58332429605895b53bb598d61b0bc29128a1d"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "mbedtls-2.28"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3360652fc82bd412633e3edff38eb5b50c9b97f20b6011f5ad4ea1853952cfbd"
    sha256 cellar: :any,                 arm64_ventura:  "7f6783ad927a719dbbb246d8bba4c83e38015748cdc89a5fd3d84115320893ef"
    sha256 cellar: :any,                 arm64_monterey: "d1df2d54bc058f4fbb5fc2896e64902c260b1aae231c036df826ecf60da3a2ba"
    sha256 cellar: :any,                 sonoma:         "496be91e220b8d14dfb26017b881b60c193460a6082b614b969bfb010f3c95fc"
    sha256 cellar: :any,                 ventura:        "064a5132a4568eb21b78a3935e3f626fb90b793a410aa2a94120d762a5b0e1b7"
    sha256 cellar: :any,                 monterey:       "2d0768c3e0524212f818baa5f9dab99358540b815e382aa747db529f7b0af8f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84ce1c2146fcd35a0cafd7775e581e729fe2e4e7a3fc13597dd48eed99889af6"
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
