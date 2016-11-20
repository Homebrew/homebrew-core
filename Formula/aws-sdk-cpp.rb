class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.32.tar.gz"
  sha256 "053637fc724dd06af61d88bf5d4fef0e7a6c26cd4966f4633cc855a43205ac55"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "99f3c9358d19d0ec1c4d05c56a31c0d94ee93499a666d5c1276a3d6bc7e00ab7" => :sierra
    sha256 "97adfec820a4506e9e215975aa9eca9da347b6eab2da9718c53876074cec8785" => :el_capitan
    sha256 "6f5472c8ef1a1d1963e6bf7c2f8ae8dc819d03b075d79a0c9ac0c5b7481f1768" => :yosemite
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
