class Ccap < Formula
  desc "High-performance, lightweight cross-platform C++ camera capture library"
  homepage "https://github.com/wysaid/CameraCapture"
  url "https://github.com/wysaid/CameraCapture/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "57ec463aa4939fdafb6d36a03ea301ce60eeef058d62b9822699953d052e1b7b"
  license "MIT"
  head "https://github.com/wysaid/CameraCapture.git", branch: "main"

  depends_on "cmake" => :build
  # Linux is not supported yet
  depends_on :macos

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_INSTALL_PREFIX=#{prefix}",
           "-DCCAP_BUILD_EXAMPLES=OFF",
           "-DCCAP_BUILD_TESTS=OFF",
           "-DCCAP_INSTALL=ON",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ccap.h>
      #include <iostream>

      int main() {
          ccap::Provider provider;
          auto devices = provider.findDeviceNames();
          std::cout << "Found " << devices.size() << " camera device(s)" << std::endl;
          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lccap",
           "-framework", "Foundation",
           "-framework", "AVFoundation",
           "-framework", "CoreVideo",
           "-framework", "CoreMedia",
           "-framework", "Accelerate",
           "-o", "test"
    system "./test"
  end
end
