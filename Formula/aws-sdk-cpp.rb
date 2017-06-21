class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.158.tar.gz"
  sha256 "c9244cd8673170d5ef7c77a3c41289d317a3a4e0f93429fa72febdd4791e1cd0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "4f029d21a5fbd5ec65aaed0ad105c4a352c34151a6191f453a602a1cb48f89a5" => :sierra
    sha256 "fdabf9b0e8043f4226d61503bbda2770053e72bedfe8bc6fb41f4b9c5596bac1" => :el_capitan
    sha256 "1c976dc8c665f81fd2a1c944affba72fa826f3fafe661fbd8af9de6042c0da5c" => :yosemite
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
