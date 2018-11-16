class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.6.50.tar.gz"
  sha256 "b86281a22913075ee9cf3cb71e24d5cf2be76221573c9b70611946a848d6e839"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dad4be50a39b394402d06fa6d507cf4c6ee21c85bed31aeb54b0660ac6b77022" => :mojave
    sha256 "a8d875c9faf9f8400e9f85921741ae94165982aac7ec0e08b399f1350672fb93" => :high_sierra
    sha256 "cabca0e43e6dc7eaf648d0cffbff6fbeda00ff3f2b586b9137af9c38c7899ca8" => :sierra
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
