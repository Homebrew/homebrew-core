class NgLog < Formula
  desc "C++ library for application-level logging"
  homepage "https://ng-log.github.io/ng-log/"
  url "https://github.com/ng-log/ng-log/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "4d7467025b800828d3b2eb87eb506b310d090171788857601a708a46825953a8"
  license "BSD-3-Clause"
  head "https://github.com/ng-log/ng-log.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "gflags"

  # ng-log provides compatibility libraries for glog
  link_overwrite "include/glog", "lib/cmake/glog", "lib/libglog.dylib", "lib/libglog.so"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ng-log/logging.h>

      int main(int argc, char* argv[]) {
        nglog::InitializeLogging(argv[0]);
        LOG(INFO) << "test";
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0)
      find_package(ng-log CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test ng-log::ng-log)
    CMAKE

    ENV["TMPDIR"] = testpath
    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test"

    assert_path_exists testpath/"test.INFO"
    assert_match "test.cpp:5] test", File.read("test.INFO")
  end
end
