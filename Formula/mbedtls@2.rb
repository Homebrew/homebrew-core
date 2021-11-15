class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.27.0.tar.gz"
  sha256 "4f6a43f06ded62aa20ef582436a39b65902e1126cbbe2fb17f394e9e9a552767"
  license "Apache-2.0"
  head "https://github.com/ARMmbed/mbedtls.git", branch: "development_2.x"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3b7925ff022e9e7a01956ddb2b48d5e4062469feb289b79566fbb380f5b7a2c2"
    sha256 cellar: :any,                 arm64_big_sur:  "ad0abc939b4b50be556177673fe5bb3a08a4a8725936d106c0c2bf599b81387d"
    sha256 cellar: :any,                 monterey:       "f797ab81818013257851207ce92ea54a2668f6f10c4011699b97c4914be84015"
    sha256 cellar: :any,                 big_sur:        "1ee8bd0e453c70b8751f9f1fb307e7915f0eaf22bfcc2c39c3fc75af9344d310"
    sha256 cellar: :any,                 catalina:       "fb6db7177cbeefc4478a32b1a1a78cc0442db7ec96cfc1760d15d221cea3b92d"
    sha256 cellar: :any,                 mojave:         "8c8611c1a3dec140495803b9dd847e1ef5dc044deab964181124309cd0be950a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a1ec575605f743ba0eb7d1e3dc9548c056d6c32da85aad2cc51c3d07463c51"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
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
