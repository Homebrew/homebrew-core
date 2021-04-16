class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.170.tar.gz"
  sha256 "1e02bbd78f188674ae144cbff48be02c37b83598be5e0ceb38bdd3d4c5288d99"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 arm64_big_sur: "492340e44ff85a25ea99b5234c6706e7231df38781688907446cc9c30db11543"
    sha256 big_sur:       "d8b721453b6d5f206cfbf97c809c03aa8b29b6beefe7874ba1147d395961f1f7"
    sha256 catalina:      "663f7e7f9dd813fa75fb75ed6cbc8efa251d527c9283df7fa7c1305dcd59f38c"
    sha256 mojave:        "2c68f9183f1988927e21dfe3ea8c634175e6cb9322a22ac1dfcfc1be9bcaccf3"
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
