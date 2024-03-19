class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/mbedtls-2.28.7.tar.gz"
  sha256 "4390bc4ab1ea9a1ddf3725f540d0f80838c656d1d7987a1cee8b4da43e4571de"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "mbedtls-2.28"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9cffb3e96fca0fb62245fe196aecbb4a65d46bcd15aa343d272818d9547db600"
    sha256 cellar: :any,                 arm64_ventura:  "9a130e1fd2ceb5128f93553e810793a71ffa078acd7169eaeaf63e787dc76564"
    sha256 cellar: :any,                 arm64_monterey: "e18a3af32a314eeab97b9ee884ea5148daa50842d5ca45e754b9357eba3edf1d"
    sha256 cellar: :any,                 sonoma:         "6d3200eb8013b68aeae48fed5b8c2282e66184660c9b6593b1942e042231d58c"
    sha256 cellar: :any,                 ventura:        "76c56def18611198619e47b25328135f7c1f9da62f36ef7f058f6e1bd252900a"
    sha256 cellar: :any,                 monterey:       "7ed776cd3f8cf1feb5287230dd233afe71b9649415d956eff81784820a6bf489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17cb1e58914d4fc714b880d03953892e5ee5731d5a0105d31878b219c9194525"
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
