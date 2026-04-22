class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-4.1.0/mbedtls-4.1.0.tar.bz2"
  sha256 "377a09cf8eb81b5fb2707045e5522d5489d3309fed5006c9874e60558fc81d10"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "afb5b23bad6eb87cd8674539459d29bbdf9faa8d73af0e2ded7b668f240f510e"
    sha256 cellar: :any,                 arm64_sequoia: "258007b03b55a6921a80ea8866ec93cb7b339c60a39d66c114098e87fe94a69e"
    sha256 cellar: :any,                 arm64_sonoma:  "d07a25b71b81662643550226f26d111cdde1b3edd270ff2d1e274ac0903309c9"
    sha256 cellar: :any,                 sonoma:        "835b7a62734a707f1429660356219758f0b0106cfbd48f844050d4456fd7e507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d406f785dbdad88c23ada7d185006570c83ca60d6cf6aa48adf196603e1ac6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15cac95836fbe3f6cd9ed6252f9651960d8e0d59842e0ac790ee0a87e282533a"
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
