class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.10.tar.gz"
  sha256 "09d54fe52ec2de9eb6b7244cf798b918ceb0958d946d8b434bf33d81ca7572a8"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "c03d8fc638156a10d777e83b0ef58541faacc135d7621991a91139c90b6fc9a2" => :catalina
    sha256 "f8c1a4774c442183976bac5527cac22de93c110704ee76f03d96670fe2fb4e2d" => :mojave
    sha256 "090a8cbf6763256bdad2c7f79bee8de6239312630d1a8d644ffb75d80bc2daee" => :high_sierra
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
