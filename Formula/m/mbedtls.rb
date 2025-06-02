class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://github.com/Mbed-TLS/mbedtls/releases/download/v3.6.3.1/mbedtls-3.6.3.1.tar.bz2"
  sha256 "243ed496d5f88a5b3791021be2800aac821b9a4cc16e7134aa413c58b4c20e0c"
  license "Apache-2.0"
  head "https://github.com/Mbed-TLS/mbedtls.git", branch: "development"

  livecheck do
    url :stable
    regex(/(?:mbedtls[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "955569c801c16788823d7ec5bdf0b714f102a441fdcebb8ce1ff298be9e9db03"
    sha256 cellar: :any,                 arm64_sonoma:  "dc2afa1e238c1d4b6fe7d6ad4a3a6d1f3a0a482c14db98ccca1f3a7678885e6c"
    sha256 cellar: :any,                 arm64_ventura: "f38f21dd538c3cb363069bb5d43e6d44ace47001d454779d39d57020a8502d82"
    sha256 cellar: :any,                 sonoma:        "89609c7efd08458940996172f6ea99fefbfad4f58d077154f88e8f435a3af04d"
    sha256 cellar: :any,                 ventura:       "4bded975092a689f6d9d140ac667479f21b43be609456b19b99e466ab8c36df0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be6abfb1e54fb3560e84a331d060ae48652381d081d6773735080183d4974a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cacb8597a11ff32804b981c95ac43147d0e141cb50080784628cd5760dfcc57"
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
