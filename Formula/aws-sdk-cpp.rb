class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.270.tar.gz"
  sha256 "8724a2c3f00478e5f9af00d1d9bc67b7a0a557cc587a10f7097b1257008c2e68"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "b86dc6ea810c79708c50d53e18fccb2497f7d2c8b0b4c4910e6eb9292a7169a1" => :catalina
    sha256 "4b8d0d5815b4f6a5dd71b53f7bf64dc3a3199fd925da12f738c99421d55872f2" => :mojave
    sha256 "c3fca0e89d8bc463a9cf96433313f3c360eb9e71216d040a663d56160ce66a4e" => :high_sierra
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
