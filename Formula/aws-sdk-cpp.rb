class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.30.tar.gz"
  sha256 "a6203e7b398ceaf348d4ed05a7de398b17b35f02705b00cdd3e2354366ebfc0e"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "e2a54d8263b6f0d6116ddb635e019a3a4fd71f146a0f6985dbde4e62b37bd983" => :mojave
    sha256 "e70fe618101f779247370eebe7c87e0038668ae89e9c7770ce8b393de9c64439" => :high_sierra
    sha256 "47feb770e42592d67aba961bfa95e8bc984a6ff48321785c1004a0019443e598" => :sierra
  end

  depends_on "cmake" => :build

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
