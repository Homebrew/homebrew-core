class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.141.tar.gz"
  sha256 "039fde2cd44d9fd9e4ca04654f7c7137ead57a9a5cc397fe39e6eb820e059cd2"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "e1c93c769730b03452265aef5f34721cc4fab5f0da953afe0a6f1fbba9ad7621" => :sierra
    sha256 "a5b32179644ebec930ad7ee42f55f4c94c50c0894cda58149ad1cdf82c5a0926" => :el_capitan
    sha256 "2e36f29aec9acf266a192c4e4b6f216a8b00d50284411d32bcd7d412645bc1d3" => :yosemite
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
