class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.28.0.tar.gz"
  sha256 "f644248f23cf04315cf9bb58d88c4c9471c16ca0533ecf33f86fb7749a3e5fa6"
  license "Apache-2.0"
  head "https://github.com/ARMmbed/mbedtls.git", branch: "development_2.x"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "d46cb00c4bd0655bd8ed88faccdf7381d8f6de212c47150d2fdb318932a0fab1"
    sha256 cellar: :any,                 arm64_big_sur:  "0e7f6871d94c4c709831f9ddc0364caa291e6d7f159e66e31acef232800c3c92"
    sha256 cellar: :any,                 monterey:       "fcbc93653e427071f72ba6a4c6eb60dea32ef2dc90af67fd193fb83c40b732c5"
    sha256 cellar: :any,                 big_sur:        "027c29a6d01c264dda1f1cd5d3ab4d2eda44af5860127f8e3fd68f9ca3f08400"
    sha256 cellar: :any,                 catalina:       "c95b68840f4f3043264176301f9f57e6804973847ba5a013afa09265fd27c81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb08fb04635126b9f35a98f04d590828de5b4bc2536203447c3217a6394166e7"
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
