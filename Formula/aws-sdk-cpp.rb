class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.157.tar.gz"
  sha256 "7bffa655fc353cea7170aadea74dbfaf1ad17e32ef97f1e80e257fd5cc30e006"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "cd1c4e4e5d364207ddc6dec2b061f4b7daac087002978f7f8f6fe8aecdecd146" => :sierra
    sha256 "5f20d6efc96ad89e5ca02c629a2eb08d8a3fd92f6e6bf6e83fbd277bd2f9e053" => :el_capitan
    sha256 "cf9a2ffc8bb47e4d5827832965aa8f1ad3bccc9bf0e9ff105e8b836198776580" => :yosemite
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
