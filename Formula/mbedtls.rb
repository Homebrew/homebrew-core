class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-3.2.1.tar.gz"
  sha256 "5850089672560eeaca03dc36678ee8573bb48ef6e38c94f5ce349af60c16da33"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0948e0625c71944abefcf31521f53675a69a5c22578e8d90be287eeb016b2625"
    sha256 cellar: :any,                 arm64_monterey: "21009291bc1c17051363355c2815cd4826603f3a3f4d0d071f78a78be2b22ae9"
    sha256 cellar: :any,                 arm64_big_sur:  "772fc2c15da4aa90218b3afdcb1c2cd076dd8333f89c951a4946fca5cbfcd227"
    sha256 cellar: :any,                 ventura:        "98585bbc5e72a7006d9da98fcb34f525224d5c7261004487d312dd4bb6d7bbdb"
    sha256 cellar: :any,                 monterey:       "b473d94ce270b5b795b842708329334a04eec7cb43fa15f4e06d9e66f8d48e3d"
    sha256 cellar: :any,                 big_sur:        "c6788160e03dfe51b88224991adecef63c269c1033349aa66e5b2b69c9247e88"
    sha256 cellar: :any,                 catalina:       "a3cba57dd337562c7793f7afc32e6ce0406c5ad31211a3250ebe7cd0b3ce9229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb233f2a360971476b190253ab1e778800309ced62c44f3409cd0d1af7a73d25"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  def install
    inreplace "include/mbedtls/mbedtls_config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.10")}",
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
