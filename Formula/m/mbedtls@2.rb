class MbedtlsAT2 < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/archive/mbedtls-2.28.5.tar.gz"
  sha256 "dbd42a11c26143aa8de1c07fd6ec6765395e86b06f583f051cfa60e8f0b23125"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "mbedtls-2.28"

  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "641b02bc5e06707db467ee883041c69d1a518f79dd6832334fe152cd7c74f07e"
    sha256 cellar: :any,                 arm64_ventura:  "ac5924611b73c46627a8c54ed551022cf0305aef7b0724fb9d958547ff509dd7"
    sha256 cellar: :any,                 arm64_monterey: "0f4fb964f3423ca69276ab34180d2553f3966f35d2fe2971deff7ef660df6cc1"
    sha256 cellar: :any,                 sonoma:         "af269f645594db17ec93d6d8c0d5f38d08608e1ba1e2c1d42f0693bd5906b635"
    sha256 cellar: :any,                 ventura:        "7040bfbafed98d68242bf574d4021b4c2088bef4fa3aec415474fed97e4b651f"
    sha256 cellar: :any,                 monterey:       "292979575ef337c38704cb5c7540305abe35d9d8f468c7eaab6f8925a656143d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e555bc546ad2ee3ea6037d9dfc4a207407cc9ed9779eba7b99b8322b24087e23"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    inreplace "include/mbedtls/config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_SHARED_MBEDTLS_LIBRARY=On",
                    "-DPython3_EXECUTABLE=#{which("python3.11")}",
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
