class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.91.tar.gz"
  sha256 "47a9df4f6fc47b9fc72cb7983361fb850e72bb33ac5ae5db3c82447ceba4eb60"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "b2218ffaf090f03ae55389d3494515af69c0edb35872aa76bf39ecd7b2f4ca7a" => :sierra
    sha256 "75f0f375e6393b00230e010d5ef9168d742e648199bc015f8ad100c0aadb3744" => :el_capitan
    sha256 "24928c245f2a4c9e7e0a88975d67841133b0f3224ce18323f519bb284b842345" => :yosemite
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
