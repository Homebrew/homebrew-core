class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.14.8.tar.gz"
  sha256 "a5f25909a98d54683b0090f89da38967d427abd08b81dae0ec5b87bd8dd81676"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "58ef1d9ca8bf4d17287971f5a72a44ad4b7f8ce46217b99893de55027dee6a02" => :el_capitan
    sha256 "3cce7e633ee1667455dcc9b043cc438eec2864d2aed19ea6f597c6739ecc6213" => :yosemite
    sha256 "f3891e6082ba66a3b2f59b58bc00b07656ae99b5c8c2679d1ded151a10b2ea66" => :mavericks
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
