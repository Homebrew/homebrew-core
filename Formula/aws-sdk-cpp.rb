class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.60.tar.gz"
  sha256 "74046306e9fb299924dfa0a149554652f0b7a279df38a7da046e7d2e84513791"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "6c79aeb104836101f0983bb58d13f1c5043af1af29068dfbd4dc26a2aea63f26" => :catalina
    sha256 "9405f59ff328ffadaac678a591fdba59a92154e48b86d6ade9dd5c49c32ff22a" => :mojave
    sha256 "21f8fd69c5f086e69ac33bc52f9e134d188f6e3c2b92db8328846ae0906a8db2" => :high_sierra
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
