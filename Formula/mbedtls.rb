class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.24.0.tar.gz"
  sha256 "b5a779b5f36d5fc4cba55faa410685f89128702423ad07b36c5665441a06a5f3"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ARMmbed/mbedtls.git", branch: "development"

  livecheck do
    url "https://github.com/ARMmbed/mbedtls/releases/latest"
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "5b8870d06fd1d2bfb485c05e1bb424e19610d1e36f896e1eced0a6fa82fb876c" => :catalina
    sha256 "20631d8cdd6f543f60753e121b6470e645a52eedf4b6289893e6a17deeff7b24" => :mojave
    sha256 "245e4e38268cb102f21fa4b4c7d63ebe105b5941ed1edc69059a7c7395f51470" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
      "-DPython3_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
      *std_cmake_args
    system "make"
    system "make", "install"

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
