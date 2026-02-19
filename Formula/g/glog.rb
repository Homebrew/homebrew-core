class Glog < Formula
  desc "Application-level logging library"
  homepage "https://google.github.io/glog/stable/"
  url "https://github.com/google/glog/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "00e4a87e87b7e7612f519a41e491f16623b12423620006f59f5688bfd8d13b08"
  license "BSD-3-Clause"
  head "https://github.com/google/glog.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15bf109a841f9381cd9086d7aecefc7d782670c90a5142bbf9f281604deff968"
    sha256 cellar: :any,                 arm64_sequoia: "c42e96a87cd7e7342ac3bf3e9c219945f116ae344b0602e9ae3274d566aa08b2"
    sha256 cellar: :any,                 arm64_sonoma:  "c4881acd951f5282803c8674b756391cac911262d4ea247daeb448457281f5a5"
    sha256 cellar: :any,                 sonoma:        "9e1493169d73ac812775f431b0f227f45d21504d0eeed8f296f7f2fcb071b919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55330f966af37454c000fe47f329a6eba4504393bf0752d35f0c3690bd2155fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c624a10ebd6da940a6f6d1c3ddb4cfe5a025bc588ece4de923aeeebadfeb8a2"
  end

  # deprecate! date: "2025-12-10", because: :repo_archived, replacement_formula: "abseil"

  depends_on "cmake" => [:build, :test]
  depends_on "gflags"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DWITH_PKGCONFIG=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glog/logging.h>

      int main(int argc, char* argv[]) {
        google::InitGoogleLogging(argv[0]);
        LOG(INFO) << "test";
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0)
      find_package(glog CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test glog::glog)
    CMAKE

    ENV["TMPDIR"] = testpath
    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test"

    assert_path_exists testpath/"test.INFO"
    assert_match "test.cpp:5] test", File.read("test.INFO")
  end
end
