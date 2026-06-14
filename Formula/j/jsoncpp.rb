class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/refs/tags/1.9.8-rc1.tar.gz"
  sha256 "f59ef533e2463bbaf1a660f4c6114462cf03be4dfdd07154c40d165bb642a745"
  license "MIT"
  compatibility_version 1
  head "https://github.com/open-source-parsers/jsoncpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5beaf350688283483e3f7c82726a8d11ec6cc88b389051916b09e21850a2b498"
    sha256 cellar: :any,                 arm64_sequoia: "a71f80781827c5677bafdfeb474711cf3b5b48a3250adf99bbbbd49d07dd15c7"
    sha256 cellar: :any,                 arm64_sonoma:  "362ddd256b7f2bd664bed9375c3697a7ffe11a19bc120f1c496fec56316b1534"
    sha256 cellar: :any,                 sonoma:        "5f5d30dac714b5dfd17f4de27349692cd949f0144ccb3780860015b87a275b98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b8d1661e7e6a7b5c6307c97ae08aea55e19bcb0587afe220e5c38a70f64a3f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7df8d9a070ee27066fb2287e2a48218ffe143ccc5bf607a701143a57dae242d3"
  end

  # NOTE: Do not change this to use CMake, because the CMake build is deprecated.
  # See: https://github.com/open-source-parsers/jsoncpp/wiki/Building#building-and-testing-with-cmake
  #      https://github.com/Homebrew/homebrew-core/pull/103386
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cmake" => :test

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestJsonCpp)

      set(CMAKE_CXX_STANDARD 11)
      find_package(jsoncpp REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test jsoncpp_lib)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <json/json.h>
      int main() {
          Json::Value root;
          Json::CharReaderBuilder builder;
          std::string errs;
          std::istringstream stream1;
          stream1.str("[1, 2, 3]");
          return Json::parseFromStream(builder, stream1, &root, &errs) ? 0: 1;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
