class Glog < Formula
  desc "Application-level logging library"
  homepage "https://google.github.io/glog/stable/"
  url "https://github.com/google/glog/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "8a83bf982f37bb70825df71a9709fa90ea9f4447fb3c099e1d720a439d88bad6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/google/glog.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db7706b1f7d29240796ce138101d3d18f02d9d2e2be542f38c5ca157e91dd84c"
    sha256 cellar: :any,                 arm64_sequoia: "0815d02daeafc23dbe271d1094bd07ab4c736f09d6f2f4db49246d1f2473955c"
    sha256 cellar: :any,                 arm64_sonoma:  "98570364c65f024c6c288284a250f9a93420b6acb45d9ed0abc5790e17d8bb85"
    sha256 cellar: :any,                 sonoma:        "1b3afc19df4514dd0bbd4368940e25df58802dde175d5b07552b8ff66d3927f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "148610f0d05d41387d7dd402fec0b7cafbe2603a7a5745734ecd6db50f279425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0624b3d83129dd0efe76d79ae8c8f5a406e98b0b6a49b7ad5d6915ed669f4e4c"
  end

  # deprecate! date: "2025-12-10", because: :repo_archived, replacement_formula: "abseil"

  depends_on "cmake" => :build
  depends_on "gflags"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glog/logging.h>
      #include <iostream>
      #include <memory>
      int main(int argc, char* argv[])
      {
        google::InitGoogleLogging(argv[0]);
        LOG(INFO) << "test";
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}",
                    "-lglog", "-I#{Formula["gflags"].opt_lib}",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-o", "test"
    system "./test"
  end
end
