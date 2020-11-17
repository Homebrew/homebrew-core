class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.90.tar.gz"
  sha256 "a4a1a8bbde876ad0c2059d27b3c9e6048fb60b9ff4c03b195dbbe70b570267c6"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "ca283d86045ca7166ed15bb043adf5fd070b9065d141dd37c35e0859b5974f19" => :catalina
    sha256 "b44d1d6238ecdf78818c901d974fc1b58cc63557c59fefdc196bcccc0526b078" => :mojave
    sha256 "102ad4e59f983ce938bd208aae92f4b7509c32a2d361517f4d34032239ce70f1" => :high_sierra
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
