class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.112.tar.gz"
  sha256 "2717b765434a453b7926c6fe89bb06f44386b095ddcc2a6db8cc11521ab78690"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "88a544348b4658e4c38b208895b312cd54a312987616a7b6a9a8f71380873feb" => :sierra
    sha256 "1e58aae8a3a518e46170f542645dccf3548bb08d6fab49446eb42480720fc2aa" => :el_capitan
    sha256 "f15321dff6966490ef5d7956538ffc070d0b8cb913cf16101fc0f3b52a4e5fa3" => :yosemite
  end

  option "with-static", "Build with static linking"
  option "without-http-client", "Don't include the libcurl HTTP client"
  option "with-logging-only", "Only build logging-related SDKs"
  option "with-minimize-size", "Request size optimization"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DSTATIC_LINKING=1" if build.with? "static"
    args << "-DNO_HTTP_CLIENT=1" if build.without? "http-client"
    args << "-DBUILD_ONLY=firehose;kinesis" if build.with? "logging-only"
    args << "-DMINIMIZE_SIZE=ON" if build.with? "minimize-size"

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
