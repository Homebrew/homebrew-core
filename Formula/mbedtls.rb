class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/ARMmbed/mbedtls/archive/mbedtls-3.0.0.tar.gz"
  sha256 "377d376919be19f07c7e7adeeded088a525be40353f6d938a78e4f986bce2ae0"
  license "Apache-2.0"
  head "https://github.com/ARMmbed/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9cc96f2c4c654cc565556a4ac9f111aebf6b406886998b728c6c0e6827ffc37a"
    sha256 cellar: :any,                 big_sur:       "84ac67a7a41cafde712cec80c31120c5f1bb896ce9d212da6d132f1c24fdb2de"
    sha256 cellar: :any,                 catalina:      "f848fa5209380ec469d00a9422101fdb2e5f57b9b588c9cadc4a35ec6fca5c23"
    sha256 cellar: :any,                 mojave:        "78827838bf19bec7b526320b8156005bfbdd92b1dd83cf8611f0abc2633f98a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff8a98b8ca64de64e9daa40ef083a05919260972400b674bcc90829e9b9a5a45"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    inreplace "include/mbedtls/mbedtls_config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
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
