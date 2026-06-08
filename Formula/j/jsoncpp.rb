class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  license "MIT"
  compatibility_version 1
  head "https://github.com/open-source-parsers/jsoncpp.git", branch: "master"

  stable do
    url "https://github.com/open-source-parsers/jsoncpp/archive/refs/tags/1.9.7.tar.gz"
    sha256 "830bf352d822d8558e9d0eb19d640d2e38536b4b6699c30a4488da09d5b1df18"

    # Fix C++11 ABI breakage when compiled with C++17
    # PR ref: https://github.com/open-source-parsers/jsoncpp/pull/1675
    patch do
      url "https://github.com/open-source-parsers/jsoncpp/commit/c67034e4b4c722579ee15fddb8e4af8f04252b08.patch?full_index=1"
      sha256 "e25bdb33c92f6b8f11f7172e884f94ba38cde6a4efbde49b683e989681e142b3"
    end

    # chore: remove leftover CMake checks for std::string_view
    # PR ref: https://github.com/open-source-parsers/jsoncpp/pull/1676
    patch do
      url "https://github.com/open-source-parsers/jsoncpp/commit/36f94b68d60774d2a5870a6881a92de02ed76eb1.patch?full_index=1"
      sha256 "33e40d0e382a1a7e5b1693039703f55ea9e3c8e1e33e2c8c73ad0a92639d1471"
    end
  end

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
