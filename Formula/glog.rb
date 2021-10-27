class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.5.0.tar.gz"
  sha256 "eede71f28371bf39aa69b45de23b329d37214016e2055269b3b5e7cfd40b59f5"
  license "BSD-3-Clause"
  head "https://github.com/google/glog.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ddb4061510011a572bb536e3a705929f7d74b26a2477db7c45f0a5273aabcb12"
    sha256 cellar: :any,                 arm64_big_sur:  "7cc04172531a192d8783f7d9d7fbaf48b8ab8849c896b089a371bd993726c30c"
    sha256 cellar: :any,                 monterey:       "ffa231a5624fecd20c2277ccec235a017896de344c4e37c4d80440db02329e33"
    sha256 cellar: :any,                 big_sur:        "cf69cacfd059791bf7c9196dfd38a170464cda435257eabe5a80428dbcd191be"
    sha256 cellar: :any,                 catalina:       "934918ceea54e2afe84fe04b179cc86fd210e804ed57d3700d2ecd0bcfc784c3"
    sha256 cellar: :any,                 mojave:         "8d66cd6d6e718969aa23d9c1fbf442fdb0da2824d40259aae5905074e838507d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31f07fd607f6b830eea772f50e07ef512ec98b2e8a74f270f0898217d56b23e1"
  end

  depends_on "cmake" => :build
  depends_on "gflags"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glog/logging.h>
      #include <iostream>
      #include <memory>
      int main(int argc, char* argv[])
      {
        google::InitGoogleLogging(argv[0]);
        LOG(INFO) << "test";
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}",
                    "-lglog", "-I#{Formula["gflags"].opt_lib}",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-o", "test"
    system "./test"
  end
end
