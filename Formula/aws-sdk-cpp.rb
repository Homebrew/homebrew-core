class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.85.tar.gz"
  sha256 "b5536e52dd3bf10f1c188b3add64524ad2a367ef303c9f2f1fdaf45a4a395e29"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "d0700c52c4c3ac8aa1cdc33e9ca20d6131b6eb8e4910b37f1e1d8d5793f97dd4" => :sierra
    sha256 "30d6bb2d0e2c3a43b795a4b97b156451a7035e2c844e653cac03a12159eef4e7" => :el_capitan
    sha256 "1125c5e3ba215c80590fcbcdd6be1882eedba7bb3c48174de5bd613ed1dbaa50" => :yosemite
  end

  option "with-static", "Build with static linking"
  option "without-http-client", "Don't include the libcurl HTTP client"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DSTATIC_LINKING=1" if build.with? "static"
    args << "-DNO_HTTP_CLIENT=1" if build.without? "http-client"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-laws-cpp-sdk-core"
    system "./test"
  end
end
