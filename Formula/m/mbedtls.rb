class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://www.trustedfirmware.org/projects/mbed-tls/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-4.2.0/mbedtls-4.2.0.tar.bz2"
  sha256 "2bed9d713b4668f76553b097e72b8aa30bc8f112a940d7ae228d524bbde6ffea"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aba0d174acd033034f91058720d55cf5c935b836c9ab95d64ebba77dc4876ec9"
    sha256 cellar: :any, arm64_sequoia: "1616865611b7ecf8b2c1480ba6b5a40210221222d78ac19f2c7d13cf936d0b4c"
    sha256 cellar: :any, arm64_sonoma:  "be5f181affb2f2648ef3c6c437224515044d11e6890eb42c7d6d7d556ae281ad"
    sha256 cellar: :any, sonoma:        "aa97a192ca8652e95ba40a174c8d61cac795fc9dedcffa8a557f97d44efbe372"
    sha256 cellar: :any, arm64_linux:   "5ce5e9e48b1610b58604b80d3deb594f4cfd27ad5eb53fb04726b28d9beb0d56"
    sha256 cellar: :any, x86_64_linux:  "ed76153a02aa91fa411c67ec1b6ccaa59417b7da9c4ac9974c3de39f77b36939"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

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
