class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.82.tar.gz"
  sha256 "ca30de683914be76ca4f5ca8c1af5d2ea2c4adb3a2ebeafd562c661e18eaa7be"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "2dfd463bc38f55c2981aafe4991c323cbf07b279f85c25cd8fac2f05979af1ae" => :sierra
    sha256 "69746399e37952be5d708d4abdc0ce462088b7edd6261456036270a6a0498cc9" => :el_capitan
    sha256 "48a5e86f88d9f3c4418d58d7cebfa7c1e42c6c662d92fdf6faa3ad8bcc6d74c3" => :yosemite
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
