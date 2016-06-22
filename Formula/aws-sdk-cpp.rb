class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.12.13.tar.gz"
  sha256 "0b939d0d26d1183e7cc1f91c9bbdc55e6a57a222cc4799b845988a633471eb0a"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "6604d938333848416b01202d1779137490c6098c6d005e12abe7906eaeaa22d7" => :el_capitan
    sha256 "a02d7d8ab13aff94ff16316f3d2db5774c9afb2d97d3b20d13cdf9f5066a7002" => :yosemite
    sha256 "54b6bf570f9e78903a84e5f8d43d4f65f082f75467832e6e14c62a2cd9717bb1" => :mavericks
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
