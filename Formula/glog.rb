class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.3.5.tar.gz"
  sha256 "7580e408a2c0b5a89ca214739978ce6ff480b5e7d8d7698a2aa92fadc484d1e0"
  revision 2
  head "https://github.com/google/glog.git"

  bottle do
    cellar :any
    sha256 "3dbfe1c481193f13798455f27962297e90d37244802fa0056af333d02236d76d" => :high_sierra
    sha256 "c5ed5359196732957cfabbe516c87437df4969547471d8ba6dff78414ab0feb8" => :sierra
    sha256 "2a7a2aef322dfd7431221bb8b5807c67d06bbe8d6407d44ed6cedceda8a45098" => :el_capitan
    sha256 "ccb8f5022bffec4a768851feb5a8cc1bf52ee7d9b8b87b8f9ce6bc4cd28278f9" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gflags"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glog/logging.h>
      #include <iostream>
      #include <memory>
      int main(int argc, char* argv[])
      {
        google::InitGoogleLogging(argv[0]);
        LOG(INFO) << "test";
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lglog", "-lgflags", "-o", "test"
    system "./test"
  end
end
