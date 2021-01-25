class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.120.tar.gz"
  sha256 "a155da9e6db3b804b09002bbee7b1a25f314c34e285ceed98f462d99ec23dd59"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "d98285da26fd55808f07710eda4cb72bcd38fb30c5aff69a0ac0eca4af9ee815" => :big_sur
    sha256 "02b978cfad1460bbbfb86be25c96d5607295b8c9be70fcd019b04c180a509599" => :arm64_big_sur
    sha256 "150a1e02ec92257f0802ffc0d41ca6e1c92a3d01516eee927f5885964871b3d1" => :catalina
    sha256 "5f0726c5265c2d0df15eabe33d3d3faddc2e51371031c55ed02f0a3fa4841a33" => :mojave
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
