class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/refs/tags/1.9.6.tar.gz"
  sha256 "f93b6dd7ce796b13d02c108bc9f79812245a82e577581c4c9aabe57075c90ea2"
  license "MIT"
  head "https://github.com/open-source-parsers/jsoncpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b67edf4eb071c0a0976e373c5a67015158f6f35bcf69f6692723aac69e9ef221"
    sha256 cellar: :any,                 arm64_sequoia: "09ac35efeac2249064d84ab26a79ac116aa9b25b91baedaf065ce7a66d9d20ef"
    sha256 cellar: :any,                 arm64_sonoma:  "a6436e046cdede285aee56208380f24d37ef592671901d7cea131f00998a5000"
    sha256 cellar: :any,                 arm64_ventura: "15a94fe13490a723ab78a54a39129e7cc39ad3e3d5e9ea67e17d6b3c3a67e021"
    sha256 cellar: :any,                 sonoma:        "8917f4a14ef0bd4f4d59f8d1a4689c653dd69180fe6ae7c3915bcd904db1d056"
    sha256 cellar: :any,                 ventura:       "22fff7a8f16806ace94150ddf11d88ccc58a86326404cd018ad3b87852df7bf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9447d9e39e2d2af144df7436aad79a6f7c3bb9cf75bb21e2409dfcae273fa4e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "460d3286f4bdf820e9426b66e3773551420c1a1dd1b3bf62d7f20bf2e7e955c1"
  end

  # NOTE: Do not change this to use CMake, because the CMake build is deprecated.
  # See: https://github.com/open-source-parsers/jsoncpp/wiki/Building#building-and-testing-with-cmake
  #      https://github.com/Homebrew/homebrew-core/pull/103386
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cmake" => :test

  # remove check_required_components for meson build
  # upstream pr ref, https://github.com/open-source-parsers/jsoncpp/pull/1570
  patch do
    url "https://github.com/open-source-parsers/jsoncpp/commit/3d47db0edcfa5cb5a6237c43efbe443221a32702.patch?full_index=1"
    sha256 "1d042632c3272e6946ac9ac1a7cb3b1f0b2a61f901bd20001bed53fc6892d0e0"
  end

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
