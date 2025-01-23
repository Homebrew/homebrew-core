class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.14.tar.gz"
  sha256 "d867ac18cc52c0f7014682169988a76f39e4cd56f8ce78fb56e064499b1d66bb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "dc7ef875d57b108a872b3e467cefb052cac8b734c08471267e179a922f092b50"
    sha256 cellar: :any,                 arm64_sonoma:   "9a6b060bf62b2c9efc9f733d24ed0cb1b31602450762d3388a62688fe1258a9b"
    sha256 cellar: :any,                 arm64_ventura:  "1adc1d48af39ae242318f4e48b0888cfa8266b4643116f21b9330eeec76ed41d"
    sha256 cellar: :any,                 arm64_monterey: "2290f29ada9966da1336ac63417339a24fc2ac42352dfe4e2284f5a551c28976"
    sha256 cellar: :any,                 sonoma:         "92f587e93b15db1517b646be60900037ff091882d8021c2a84543fb35100265d"
    sha256 cellar: :any,                 ventura:        "d4fb3e4d646e1a9127a3fef855e67f7aa5199a99d4f533858e0f9374a10a5e69"
    sha256 cellar: :any,                 monterey:       "b54ec74fc1b3ab3b07ae89bb871c58a9ab409038ee921f9b2a8b8b430e96f56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "661f88d5c8155914a68aad5e50cc1b2e2f1db79adc3c708e1c10f10a25bd4726"
  end

  depends_on "cmake" => :build
  depends_on "primesieve"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                                              "-DBUILD_LIBPRIMESIEVE=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "37607912018\n", shell_output("#{bin}/primecount 1e12")
  end
end
