class Cctz < Formula
  desc "C++ library for translating between absolute and civil times"
  homepage "https://github.com/google/cctz"
  url "https://github.com/google/cctz/archive/refs/tags/v2.4.tar.gz"
  sha256 "e1a00957d472044808a24a26f1ba020f36dc26949a69c214562d96b74093adb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "12f4fd08ce0235acfae73b1af5f3cd618fe5d4c7675fd448ba0affe004df3f64"
    sha256 cellar: :any,                 arm64_ventura:  "29b3eda980b49d6194c0f6c84fef48e506430fd5e01742e8778bf54c7b6340ab"
    sha256 cellar: :any,                 arm64_monterey: "0b0c26679d5fade184996abebcb2c2f3d5403b5d3ab49195c8649bed52690dbf"
    sha256 cellar: :any,                 sonoma:         "067e248e5286cd504f20909c5ce08b8747533a99dfdb100c6d82a729961c3e9b"
    sha256 cellar: :any,                 ventura:        "5b47b57312c19fddd60a02d403dfcb80920de82b9691bed95364f764c40760af"
    sha256 cellar: :any,                 monterey:       "a0f00e1a70014af1dd61f874e232a20059e26aeed1c2d941c3bcc1785f2e947b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62ae3155aafe87fc71fbbecdd8b2ceaa0e57c03d32e29b6349614b73ce0c4192"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"

    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *args
    system "make", "install"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <ctime>
      #include <iostream>
      #include <string>

      std::string format(const std::string& fmt, const std::tm& tm) {
        char buf[100];
        std::strftime(buf, sizeof(buf), fmt.c_str(), &tm);
        return buf;
      }

      int main() {
        const std::time_t now = std::time(nullptr);
        std::tm tm_utc, tm_local;

      #if defined(_WIN32) || defined(_WIN64)
        gmtime_s(&tm_utc, &now);
        localtime_s(&tm_local, &now);
      #else
        gmtime_r(&now, &tm_utc);
        localtime_r(&now, &tm_local);
      #endif
        std::cout << format("UTC: %Y-%m-%d %H:%M:%S\\n", tm_utc) << format("Local: %Y-%m-%d %H:%M:%S\\n", tm_local);
      }
    EOS
    system ENV.cxx, "test.cc", "-I#{include}", "-L#{lib}", "-std=c++11", "-lcctz", "-o", "test"
    system testpath/"test"
  end
end
