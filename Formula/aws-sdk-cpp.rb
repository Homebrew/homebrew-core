class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.13.4.tar.gz"
  sha256 "93ded7a4569ed48e83dd0d154d9584f89137e6632c66ba231a8720749014e5d6"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "8869807e061b44c19e9c7953ac5f6a4c9dcdb30cb79ee46d3fb3c9dbe6c8b99b" => :el_capitan
    sha256 "01a59ad4cfc4cb334152f126aab603262372c7a7ebb528d84e7c7c92d91ce365" => :yosemite
    sha256 "a0f58256a4b519d3391a7df33c4d12aeec5bfb236e3e25805e65d99f9e9c9b51" => :mavericks
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
