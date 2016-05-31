class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.10.15.tar.gz"
  sha256 "88c833843b852920e228f7748c703f822770ee6e9595de55bf4b027b12547f06"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "774221f42462fd65ab097e379fcfd4a98fb0866421e6ab2e9e16c134fbb1e3b4" => :el_capitan
    sha256 "300dfde40bda133c737345ae03160060c6fb9a8c88e7dcbbd848769d48804ad6" => :yosemite
    sha256 "696b6ddb5f88d8d8a2729a36962b0ae2bbb584caaab27cf6fb9b25f338278d21" => :mavericks
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
