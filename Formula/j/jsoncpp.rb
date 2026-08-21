class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/refs/tags/1.9.8.tar.gz"
  sha256 "51828cf3574281d2b79ec2a1c56a9e4c20cc1103711321ea96384cffb8d2d904"
  license "MIT"
  compatibility_version 1
  head "https://github.com/open-source-parsers/jsoncpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "55ef2699e0d62974c6a003f1c749531f42bf6b037e6cb9b599ebba62f1924f57"
    sha256 cellar: :any, arm64_sequoia: "6fb31a47e19e5b82609abc2f8d8ca6f60e1d194d3e2bc3704f1e57c4254cf157"
    sha256 cellar: :any, arm64_sonoma:  "cf9175a5074e7a9624bdbac0d16cbc51d243f99706542b2872a4e544d78c0e04"
    sha256 cellar: :any, sonoma:        "f6644b07c9763892e4494d76585cfce332ae5e58920018cec08024241fc5ef67"
    sha256 cellar: :any, arm64_linux:   "e095696952c7a46c28423505848ee7b1b470cecdb37b520fd8bf5649d30af0f4"
    sha256 cellar: :any, x86_64_linux:  "83f729c1a4d14b718ed349f9fda478e955b87809e80cca0a9c249313712c69c3"
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
