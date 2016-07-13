class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.13.3.tar.gz"
  sha256 "e375f8025aee6b76c95c123fa4e46509f9d570fcf5d19ae53a79825d50885215"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "faa4916815c9cd0b8dd24889ab3e1abc83b3e73d072433966dbf0c9c4ff5d154" => :el_capitan
    sha256 "e5bbc06273ae76a5380ac92f5fdd1f803ed992bfd0f1a29e910c26e2ec7f99ce" => :yosemite
    sha256 "88b70c7a8d95358fb156870f9377cb2e6ab6a73339da9e6acdc477980efcd849" => :mavericks
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
