class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://www.trustedfirmware.org/projects/mbed-tls/"
  # TODO: undeprecate if upstream finds new maintainers to continue development
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-4.3.0/mbedtls-4.3.0.tar.bz2"
  sha256 "1c87cba094cb40f097ebe0eba440a74939b71dab4e1d0d566bc90749ff381d18"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "15510975e7d3b547052e4bfa40ceb3002f3220d51a063775d98a9fe6aa082456"
    sha256 cellar: :any, arm64_tahoe:       "4f8596f46c4394ba8548bae619b2d513ca9c22a0018bc0395a4d74e47d3d077f"
    sha256 cellar: :any, arm64_sequoia:     "5283dd60123a97b2732571dd4641a77233817ab7bce0f14d35b316c44d077e0f"
    sha256 cellar: :any, arm64_linux:       "fc9e800d2e9ee449fdb98458e85d990a02b76554c8322438867fc34ad0fff474"
    sha256 cellar: :any, x86_64_linux:      "511c090c62eeaf041e5c047667b8a6ecb5b2c2d996aef940cf5bdcec9e61eb9d"
  end

  # https://lists.trustedfirmware.org/archives/list/mbed-tls@lists.trustedfirmware.org/thread/YPIGCB7WN6GCHOGEGKOJXUYAP7OK527W/
  deprecate! date: "2027-04-01", because: :unmaintained
  disable! date: "2028-04-01", because: :unmaintained

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  deny_network_access!

  def install
    inreplace "tf-psa-crypto/include/psa/crypto_config.h" do |s|
      # enable pthread mutexes
      s.gsub! "//#define MBEDTLS_THREADING_PTHREAD", "#define MBEDTLS_THREADING_PTHREAD"
      # allow use of mutexes within mbed TLS
      s.gsub! "//#define MBEDTLS_THREADING_C", "#define MBEDTLS_THREADING_C"
    end

    # enable DTLS-SRTP extension
    inreplace "include/mbedtls/mbedtls_config.h", "//#define MBEDTLS_SSL_DTLS_SRTP", "#define MBEDTLS_SSL_DTLS_SRTP"

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
  end

  test do
    expected_contents = "This is a test file"
    (testpath/"testfile.txt").write(expected_contents)
    # Don't remove the space between the checksum and filename. It will break.
    assert_equal expected_contents, shell_output("#{bin}/zeroize testfile.txt").strip
  end
end
