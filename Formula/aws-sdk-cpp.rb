class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.12.4.tar.gz"
  sha256 "e448873892d418da79691d91d55c4fe702769d5e1d83ce327483cdc2680322bc"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "ac7fce2244a03fc76ac2ec7317f8f45b4eba872d39731cd51cb16134d591fca5" => :el_capitan
    sha256 "c37e861a7e3d68187c9bb95f8fffc710097c8c3eee7a29992f4e028e90e8fdbe" => :yosemite
    sha256 "f0326b342c98ff4d19b000f1e9fc8516401f0951d3dbe6a286911aabcea9c8df" => :mavericks
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
