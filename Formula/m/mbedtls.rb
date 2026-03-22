class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-4.0.0/mbedtls-4.0.0.tar.bz2"
  sha256 "2f3a47f7b3a541ddef450e4867eeecb7ce2ef7776093f3a11d6d43ead6bf2827"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27ea10c369948aae4c0569064e1b8628ca5fd5dcab0bbb02214f494b2bf3f2bb"
    sha256 cellar: :any,                 arm64_sequoia: "0c694fd452f2098a5d0e6987e387e38c15ec98911a4a5ef708d22813cedc5a4e"
    sha256 cellar: :any,                 arm64_sonoma:  "2e575f2b42bec807a9b044ab00b07f28dbddf4630e5235d053584113d3779abf"
    sha256 cellar: :any,                 sonoma:        "c96bd36a7136fcf036acff89c6e71fc91bbed9d4b20905d7dceeb0b5ba3c26f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fba7c9b4c5b1562ec7161c3406b4a87b5b7fcce2b372fab323261482c96ea253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df82e43cbff336f226c4ee56c7db63190cb3915af6287fad76b99c458f1fb4bc"
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
