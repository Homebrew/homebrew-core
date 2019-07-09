class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.140.tar.gz"
  sha256 "635ef8a06d38e7162c104299102b98f53b1542276c8fae880ecd39d4492bf456"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "2136c104893247e49e2be275b67a45fae7e489094661db548525d49abaf1bdfd" => :mojave
    sha256 "d33958b889b3f7b44156608a72253a7dbc881d8c939e912f316d673dccac2ccb" => :high_sierra
    sha256 "d833c008ec4905a64921b06e17b999ac6d34427e030ff8ce7681427f99bc4b56" => :sierra
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
