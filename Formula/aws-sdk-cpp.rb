class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.4.tar.gz"
  sha256 "ad6c36d5479260aae0025b3396ac10b8ac435c77128dd8a75b7ae9d41238c581"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "2bb463c090d7a011ef796d6f0789300862edcc9fb8c9a8c57da1cec2f5c62afe" => :el_capitan
    sha256 "c80037ce83e85ad6b6dea5a46f3c3b7204698cf7fc1b32815acb0ad961f2bad0" => :yosemite
    sha256 "1d24ca9fb77b457ff320f05e1a5e9e9f11b2f50d61b8686fe75668ba9c66e944" => :mavericks
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
