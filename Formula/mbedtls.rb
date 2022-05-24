class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-3.1.0.tar.gz"
  sha256 "64d01a3b22b91cf3a25630257f268f11bc7bfa37981ae6d397802dd4ccec4690"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "61f953e197aae82f30b1126b09282e05603cac9e3510ee16c8ee5c0a5bcd6d3d"
    sha256 cellar: :any,                 arm64_big_sur:  "e1e3ce34caf7ef745cfe8323c3d21b700c741a7c57580155b57801e5355457a1"
    sha256 cellar: :any,                 monterey:       "c3cdf015e35cdc96efd81c2753e7c8221450f6d9a8e9c734428d0ef68560aa22"
    sha256 cellar: :any,                 big_sur:        "5f1bac917553013e1bf45a31cc8f64fe056ddab8aa8de6e2511d5151207bff9c"
    sha256 cellar: :any,                 catalina:       "e6c515156e725ebf371f8d756a87d7504cb2064c65b8aaa10c7ba389b54d8a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d105883b858a0eb7b822c2c47b7ef2be7011836743075f3e8777e8f97cfbfe06"
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
