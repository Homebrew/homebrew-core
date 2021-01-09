class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.120.tar.gz"
  sha256 "a155da9e6db3b804b09002bbee7b1a25f314c34e285ceed98f462d99ec23dd59"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "92521fa0aff56aa4eccf0398cf597abecdc93a8f6cbc59dadadd8f7acf6f9f7d" => :big_sur
    sha256 "1b9d34aeb806c71b31c46a863e71ca8cb11903e814e6adeece9f65d562b1cfc4" => :arm64_big_sur
    sha256 "32046e5e0f89c53597aa5e8698ec9190b396a2719cef4638198bcaad1da5c34a" => :catalina
    sha256 "4693d20e0a1cfaf8091078cf85552c51e925550cf425a70de41317aa2c23e83b" => :mojave
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
