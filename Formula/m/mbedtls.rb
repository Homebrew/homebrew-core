class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-3.6.1/mbedtls-3.6.1.tar.bz2"
  sha256 "fc8bef0991b43629b7e5319de6f34f13359011105e08e3e16eed3a9fe6ffd3a3"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "19178129a2b03ef21d5ea5d51067bf7a8a734d72c9a779207bc9ea9c5a4c9280"
    sha256 cellar: :any,                 arm64_sonoma:   "85ebbef174334a956d09467ae5f96664a80ddff5e4907d29b19f6dba93312323"
    sha256 cellar: :any,                 arm64_ventura:  "24958180338112358f8d047c0dacb29d142b9ef7991ecea44c065ce3a31a395c"
    sha256 cellar: :any,                 arm64_monterey: "9da50d1a90d39a1a72b682de00b11f9525f4966dc2274ad3254072360247c6a4"
    sha256 cellar: :any,                 sonoma:         "00860dfbfe01e85918c698b95c50a40c1cd7e102ffaa548d17be6d7c1e27ab81"
    sha256 cellar: :any,                 ventura:        "2d4f92d6cc330d519f999550cb1b2dc3e29bd3d10724bec8a5a5dca4cdff8189"
    sha256 cellar: :any,                 monterey:       "8a5d71363939adf144c111501bcfa530e729c6a8d975d141415db895f8c3a182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccbe393ef900a7aa55413c62c8a5e39cdd0b17a3e69edacc213cacb68faf59c5"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build

  def install
    inreplace "include/mbedtls/mbedtls_config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
      # enable DTLS-SRTP extension
      s.gsub! "//#define MBEDTLS_SSL_DTLS_SRTP", "#define MBEDTLS_SSL_DTLS_SRTP"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.13")}",
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
