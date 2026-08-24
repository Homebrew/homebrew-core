class Glaze < Formula
  desc "Extremely fast, in-memory JSON and interface library for modern C++"
  homepage "https://stephenberry.github.io/glaze/"
  url "https://github.com/stephenberry/glaze/archive/refs/tags/v8.1.0.tar.gz"
  sha256 "8cc479b53e4612fad2b4b74a079421d5ea897944e54a9ab5d1207cd68cf52b9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e047927af75dfc951acb8ba90232858679bed8b79fbb62ca35a27e7c275c626"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => :test

  def install
    args = %w[
      -Dglaze_DEVELOPER_MODE=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(GlazeTest LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 20)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(glaze REQUIRED)

      add_executable(glaze_test test.cpp)
      target_link_libraries(glaze_test PRIVATE glaze::glaze)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <glaze/glaze.hpp>
      #include <map>
      #include <string_view>

      int main() {
        const std::string_view json = R"({"key": "value"})";
        std::map<std::string, std::string> data;
        auto result = glz::read_json(data, json);
        return (!result && data["key"] == "value") ? 0 : 1;
      }
    CPP

    ENV.append_to_cflags "-DGLZ_USE_STD_FORMAT_FLOAT=0" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", "-Dglaze_DIR=#{share}/glaze"
    system "cmake", "--build", "build"
    system "./build/glaze_test"
  end
end
