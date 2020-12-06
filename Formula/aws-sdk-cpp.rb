class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.100.tar.gz"
  sha256 "c1ebe94cc0b3df7853cbe4d9c5d15ca1dccabff94d5c3f075d15eb1f41d17dcf"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "8492181fa11e00cb92c931ed6770584cf0a6c01f74a2f0cb41b3a94ee1c2c03e" => :big_sur
    sha256 "c74dd5eb661d71c8db39c04d054310c60b2695eeb3fe6fa3aa2a03a4c6965037" => :catalina
    sha256 "0c732f115863ea582eba84ac7a568f397263e6d3de082a31c275e34b30eea8a9" => :mojave
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
