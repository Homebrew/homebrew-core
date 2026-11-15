class NgLog < Formula
  desc "C++ library for application-level logging"
  homepage "https://ng-log.github.io/ng-log/"
  license "BSD-3-Clause"
  head "https://github.com/ng-log/ng-log.git", branch: "master"

  stable do
    url "https://github.com/ng-log/ng-log/archive/refs/tags/v0.8.4.tar.gz"
    sha256 "e154857d99d4ab6246a1bbde607ddb60f4bd6b1912c4f044a81f688cc89fcdd0"

    depends_on "gflags"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e0eeba20eab668631b51933cbc5f2e546fc5b9f241fadb048f217fd9360b8e02"
    sha256 cellar: :any, arm64_tahoe:       "48b17089d29acefbd4dc2cdecccef9c40b88e600b310ae9a161ef07e5e6cdc74"
    sha256 cellar: :any, arm64_sequoia:     "62712c2766a71cdaa0fa8d7b5c61d681b4986ad203ae17522dff3b87ad8256c2"
    sha256 cellar: :any, arm64_linux:       "d17f12fdb0bb93ca1225d8648204822638e78fee49995e22d317857158a8e5d8"
    sha256 cellar: :any, x86_64_linux:      "d9a5e0ef6cd5376ab76be3cf1f6087c8e476ca984d98e61db026813bee02aff2"
  end

  depends_on "cmake" => [:build, :test]

  deny_network_access!

  def install
    # Not building glog compatibility layer as most dependents don't work with it
    args = %w[
      -DBUILD_COMPAT=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_SHARED_LIBS=ON
      -DWITH_PKGCONFIG=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
