class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.180.tar.gz"
  sha256 "2c4ec21834b75f7e3f426901eb42ea33836de46a91c61ce24d295885b591a3ec"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "4d6c34f0e34624735de7234e30ce6b5a6e25e96aa01ac22d1490eeb48fe15f4b" => :mojave
    sha256 "2155469aff958aa07a2edfbfef851217d985eb50dbf57b7674dba5150fb2e294" => :high_sierra
    sha256 "5d8a2ec7c321103117c5d7f0c91fa70ccf53e2c063baca0a295a3a9bdcff7237" => :sierra
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
