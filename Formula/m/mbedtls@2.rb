class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-2.28.4.tar.gz"
  sha256 "504bd29af6e7f9f3de1f0f7b7e16c73987a4194338681acd72b82383a49d55d5"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "mbedtls-2.28"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ea5e35f7626f0c478feef8a8b3f882bdd731738d9562db85a0833bf8cb12a23"
    sha256 cellar: :any,                 arm64_ventura:  "9a0e0a10c5ed6da48794715b6f519825ce8747fb5099440a8fe5a44f18760c4f"
    sha256 cellar: :any,                 arm64_monterey: "f96163b97c0e311c87603f43f45e487387f85e6ad8b94b8c63f22194cd7703e1"
    sha256 cellar: :any,                 arm64_big_sur:  "0435476d8db7e774139ee56e5afe91e233ab9d6e83f262a7ecb80e337018217a"
    sha256 cellar: :any,                 sonoma:         "22e1dbbdac74cb06a6a3629de43bcff451b2cbced36fc939604e94e892e04f00"
    sha256 cellar: :any,                 ventura:        "94818a3b4b8b7466e1951da1c6b2ee45c86f037f079779863668562d5c8bfa1d"
    sha256 cellar: :any,                 monterey:       "fd758c1766ad4f156d7d8cc3ffe4f8340cd1dddc92e32539570cd09705e9ca7b"
    sha256 cellar: :any,                 big_sur:        "1f3dc36a4634ce9df031b250dc4c8e9c17418bfd32f4f8cc49f88ecce5dcdfcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ea7e6c4fab22043a8a4c65f2fc58f7874924f65cbc8a98d5d824646bf95d29f"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.11")}",
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
