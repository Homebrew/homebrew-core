class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.85.tar.gz"
  sha256 "b5536e52dd3bf10f1c188b3add64524ad2a367ef303c9f2f1fdaf45a4a395e29"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "15d97c4e80cd4abc0e487d5bfd871821d1042a7a593a05d45a306f371b30541a" => :sierra
    sha256 "9053e6bc7374f092d2ae656b7806440716fcefc3ad87f45c4077e2dd8dfbc39c" => :el_capitan
    sha256 "1d2e70e0994819e6f9377baaa6761e7cc0acc3bdbb1fae9ead0312b8ecec0109" => :yosemite
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
