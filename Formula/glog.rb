class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.3.5.tar.gz"
  sha256 "7580e408a2c0b5a89ca214739978ce6ff480b5e7d8d7698a2aa92fadc484d1e0"
  revision 3
  head "https://github.com/google/glog.git"

  bottle do
    cellar :any
    sha256 "2611ad281e7bf92bc8fb1480661ac1e28e7472d3eecad63572aa1f205f494722" => :high_sierra
    sha256 "8f4b25fe4396b3f32c7a7d058260b453adf2506e1d3a607d0ff48e664489526d" => :sierra
    sha256 "24561c61283ee126c107a5fbb2131ebcab0903df9f4af99bebf4fbf04a0fdf90" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gflags"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end

    # Upstream PR from 30 Aug 2017 "Produce pkg-config file under cmake"
    # See https://github.com/google/glog/pull/239
    (lib/"pkgconfig/libglog.pc").write <<~EOS
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include

      Name: libglog
      Description: Google Log (glog) C++ logging framework
      Version: #{stable.version}
      Libs: -L${libdir} -lglog
      Cflags: -I${includedir}
    EOS
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lglog", "-lgflags", "-o", "test"
    system "./test"
  end
end
