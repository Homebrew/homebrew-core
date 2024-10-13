class Cctz < Formula
  desc "C++ library for translating between absolute and civil times"
  homepage "https://github.com/google/cctz"
  url "https://github.com/google/cctz/archive/refs/tags/v2.4.tar.gz"
  sha256 "e1a00957d472044808a24a26f1ba020f36dc26949a69c214562d96b74093adb3"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "43ec1e3404f1eb3f05f967649c764aa06a7e4a8c32902214343a72676ffda5c7"
    sha256 cellar: :any,                 arm64_sonoma:   "eba6f2dc7740b64f07d96b4f408c51ed5adb7b948f7c6261155ee5da4e43c991"
    sha256 cellar: :any,                 arm64_ventura:  "dc5b93076b8c9637ebd074539ed68f79a967234d1ed59451e80b708aa438a499"
    sha256 cellar: :any,                 arm64_monterey: "2279fd2c826ddff71e1162f8b67829b34295a21f271352c0640b6f44c3e331c6"
    sha256 cellar: :any,                 sonoma:         "0ab1b384f0a647a473f481323cfa13164494affa91cbffc5dfa6b41ebc97da72"
    sha256 cellar: :any,                 ventura:        "160d4ac726f11db6d03d917e0a1acb9d61bb5a45a24b120b8f094a5000d7d127"
    sha256 cellar: :any,                 monterey:       "a8256df066d659ca817adab5b1054633547514c650248f479ec6e31a3c12732e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "897ed11efc1b5804873b9c64315d78f99cb4e242f3ceb554dfc8d760ac65b03e"
  end

  depends_on "cmake" => :build

  def install
    args = ["-DBUILD_TESTING=OFF", "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"]

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_static/libcctz.a"
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
