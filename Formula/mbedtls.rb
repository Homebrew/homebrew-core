class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/ARMmbed/mbedtls/archive/mbedtls-3.1.0.tar.gz"
  sha256 "64d01a3b22b91cf3a25630257f268f11bc7bfa37981ae6d397802dd4ccec4690"
  license "Apache-2.0"
  head "https://github.com/ARMmbed/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "b141cf7a322999c36407a006f6c4eb3a5f2727f5611383305a53537ce2111ca3"
    sha256 cellar: :any,                 arm64_big_sur:  "2d76e87d5ef8953fb6d48576e5e9746b842e28c803a8d37fe52fa85a2093a0d7"
    sha256 cellar: :any,                 monterey:       "69aec9cefc9e9ebb515b1c529eddf2dcaa04aede0ab560af4b8f0092a3c0865b"
    sha256 cellar: :any,                 big_sur:        "3900a7a8b0864fd6e318f1f9e27fe05ab5878a9323052edcfa7b4c50f3a2e71d"
    sha256 cellar: :any,                 catalina:       "259d2b3aa5a7a74827ba187fbf0254f169a264d7844d72a1c6dec4f33519fee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b4b25f527c3293322f61e61124ece8e694f3fdf21fc9f19f91eba22d2b7bae0"
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
                    "-DPython3_EXECUTABLE=#{which("python3")}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DGEN_FILES=OFF",
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
