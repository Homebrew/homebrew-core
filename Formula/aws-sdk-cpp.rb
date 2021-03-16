class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.160.tar.gz"
  sha256 "b3ed277b6d36879102677f13fa2fabcf0abfa7535a226aa51bd150625f738fd2"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 arm64_big_sur: "77470a013b64f70cbcb6bfa476dcecad7ecf14e84b4c2436581a06cfecf012e3"
    sha256 big_sur:       "3c270152433557e1ec32190227ce3519a7dfa8e42204b43623a1d1f64aa93170"
    sha256 catalina:      "71a061eb4fc33e9b284a8a4b7639e424127aad69ce56fe225678eb9cef443b8b"
    sha256 mojave:        "0dea01ab14956b34d01ff45883e8b37610e40e7b901a82626ddcef76706b3e33"
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
