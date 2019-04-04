class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.80.tar.gz"
  sha256 "9f7576892155d577663f4b0066521e15ef88e30760a79877ec4d4040cc120cba"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "999a6127db3210ae240bba7dfbb1760f880cd651a2dcb1c0f4210cc60b2dab26" => :mojave
    sha256 "b159ecf5d14f559de262db80fe123dc69e51edb0af8196f4d2143e0a1311b75c" => :high_sierra
    sha256 "28d2b0807134d032e757e46f2586f9fc98051d87d730ebca0bd349d3b2b29f82" => :sierra
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
