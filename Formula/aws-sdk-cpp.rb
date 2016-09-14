class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.6.tar.gz"
  sha256 "a0b71873803cee8d4f4b47bc16486af73c14d2286ce894686bc484860af3b70f"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "fafc0f77c8cc869a4fa3e9d6c4ecaff33eed33110bfb55fd2226bc95bc29ab1e" => :el_capitan
    sha256 "81bed096bd9e67061bdda6fee9053dcf7e49c7af8a42d5cc524f69021b61d373" => :yosemite
    sha256 "53445262ec9e42be7e9ee2a14a8c715633c819a27e169dc27cd9b34fa1a98d1a" => :mavericks
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
