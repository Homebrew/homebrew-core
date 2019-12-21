class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.250.tar.gz"
  sha256 "5aa14947c45f66a63eca0a5667117f23d0b5cf4ddb1b82c63d51e692e833cb4d"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "44d9c79d35d07bc9b1b1a5bcb9e55a93c93bb98659026c1ea6aab22dec6f5c02" => :catalina
    sha256 "ee825cf162018066103e3b18a0144012f39702dacbd5f7514267e7e42709de59" => :mojave
    sha256 "fc61b5961148580be5ebe8267167aecd3bf6cb206f9506bfdb08256e7bc04ec3" => :high_sierra
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
