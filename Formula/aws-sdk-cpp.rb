class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.140.tar.gz"
  sha256 "21eac4132ccc66cf1519243b7d7d951403b69074b8f818efe14cc8dd439e089b"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 arm64_big_sur: "f84804c7e288bda13c8e522bb0380b7f753b1ca51b6862c3195a8bfd724c2ed5"
    sha256 big_sur:       "68c570bb4f3d27fa8915bdaafc0875fad7c880455b7c8a3cf16510374461a997"
    sha256 catalina:      "2074dd2265c8dcdb4e648ebebec1c938a5981851ed1c2f3e115a114c14467274"
    sha256 mojave:        "3da4fe80b53a1534516e063ea071871b9f886feec0f988b6d9bee15dcac0d9bf"
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
