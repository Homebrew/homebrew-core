class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.6.0.tar.gz"
  sha256 "8a83bf982f37bb70825df71a9709fa90ea9f4447fb3c099e1d720a439d88bad6"
  license "BSD-3-Clause"
  head "https://github.com/google/glog.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f027456418cf100e83da0cab5dd2f01b03650d25727fc129ae8bfc80031469f"
    sha256 cellar: :any,                 arm64_monterey: "875364220b0fae1b16b63ff9811aa675d1fc55e47fd5ea64ecfb15ce063965b2"
    sha256 cellar: :any,                 arm64_big_sur:  "8a33b84bd59fa19c00401e5540a41207f2364867783b85289a2153cc4da2b861"
    sha256 cellar: :any,                 ventura:        "1bf4cd6c05c5b63c05bf91c854902bec0a3f2c0058d26d7277df53c4791d7aef"
    sha256 cellar: :any,                 monterey:       "04b418eda3d8089e64ab902d265dd935245c815b19933173f670a28d8abbca81"
    sha256 cellar: :any,                 big_sur:        "54cac16cc76e3594f3b61afa071ebb7890a1cc22122cab767ae540ced1f1a24b"
    sha256 cellar: :any,                 catalina:       "53e6963a265a0af5d6982b91e423f432f0a130995cc7e2e2021a04edbbc8a88d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04695a6df86ea26cadda86975bc9ad9c1ec112e8325e2bbc5f25939b42698463"
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
