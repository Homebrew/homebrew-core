class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.23.0.tar.gz"
  sha256 "5c8998217402aa1fc734f4afaeac38fad2421470fac4b3abc112bd46391054fe"
  license "Apache-2.0"
  head "https://github.com/ARMmbed/mbedtls.git", branch: "development"

  livecheck do
    url "https://github.com/ARMmbed/mbedtls/releases/latest"
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "3b1d3f3b161a1cd7d570281baaec5412adf9ae1b2bf5eb842e04571f3bf17c4b" => :catalina
    sha256 "6a061c88f257cce7187aa50bb1406f517ff49e9279f917e2eceae1ff446fc792" => :mojave
    sha256 "57ffbd38b650a3850c5bca98840dd2c9b3b9a000af499b5237d68e73f5f088d3" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-DUSE_SHARED_MBEDTLS_LIBRARY=On", *std_cmake_args
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
