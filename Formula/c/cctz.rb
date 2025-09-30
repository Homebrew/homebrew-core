class Cctz < Formula
  desc "C++ library for translating between absolute and civil times"
  homepage "https://github.com/google/cctz"
  url "https://github.com/google/cctz/archive/refs/tags/v2.5.tar.gz"
  sha256 "47d2d68e7cb5af3296dc7e69b0f4a765589f1b2f4af4b9c42e772414c428b421"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6284d05bd82c833d038e7fe7a1b46288db768f917dc7a54c0cbd0ec60ef49474"
    sha256 cellar: :any,                 arm64_sequoia: "2712e262130449fd148e9e269ef211baaf180ad6fdee8e53ae0677d5edff39c1"
    sha256 cellar: :any,                 arm64_sonoma:  "e08d896c8857b05cfd0f0acd71c0c4da9d7f4d87885ab70e3f942156c6052c59"
    sha256 cellar: :any,                 arm64_ventura: "0142de2c33e7260a2d5733ab54fdce84958d0d511d4f6b9b46f4b89c42b83aa4"
    sha256 cellar: :any,                 sonoma:        "48dd11816116da849effe5f734883373c47b676c25e9704bccd477b4ffa76cdd"
    sha256 cellar: :any,                 ventura:       "dddb31e05731af18d90829688081aaeffb2aaa4a8dda83975e88a1abf1c0c5f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "032ab04e69e1f663c647f6e40ffbc590a349b4cbae8b69a6d33193169f4a4210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c1b89beed6a56b0b9220e98b9eb6fc671b7d8876a753426a424318d809355a"
  end

  depends_on "cmake" => :build

  def install
    args = ["-DCMAKE_POSITION_INDEPENDENT_CODE=ON"]

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_static/libcctz.a"
  end

  test do
    (testpath/"test.cc").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cc", "-I#{include}", "-L#{lib}", "-std=c++11", "-lcctz", "-o", "test"
    system testpath/"test"
  end
end
