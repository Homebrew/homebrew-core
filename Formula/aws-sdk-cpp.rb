class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.14.3.tar.gz"
  sha256 "897c92f562ccd31893224761e4c0c76279c7f85f84e33b11735f131e2a094db8"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "615fc4ddfa76a512be112d00da7ccd008b00b3e3c3741b8cb91bba7f075d56ec" => :el_capitan
    sha256 "d57d017b97d21f5b99ed6351c1edd8a70462dba8ab2fee8e6ca1f9ab345cd42f" => :yosemite
    sha256 "700740ef0ffccdae37d510f5bd19ba644f91ce1ba1491cc32d7e82d1a9ca5e39" => :mavericks
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
