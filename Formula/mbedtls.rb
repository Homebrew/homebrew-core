class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.25.0.tar.gz"
  sha256 "ea2049c2dd4868693998d5a9780e198194be5aea1706ff4a9d4f882f18c0a101"
  license "Apache-2.0"
  head "https://github.com/ARMmbed/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "a4695cc4145069a599b42bcd2f4874b3d73b28cf25cde43b0092618411aa23b4" => :big_sur
    sha256 "4af48178496d7885d13ae9f80dd8057b38645ddadf6c6e67440819062ed99f8f" => :catalina
    sha256 "eda0fab1ad56d159c997569df7a70bbfe8c127963166c2835613cb241ff88d17" => :mojave
    sha256 "99527f9ec94aa2754bd335c308936c53a6f09106e2edede4b39fc80340ed3cdd" => :high_sierra
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
