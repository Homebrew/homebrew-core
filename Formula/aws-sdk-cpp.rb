class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.49.tar.gz"
  sha256 "29e3ca819d8bcbec418e5bb1b7fc183bcb8717008ed0a8fc636976b15b649eb4"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "b1baa65c31fce116f785d87ec0e367cc00b3809b8a769b97a5fcf23ba9bed35d" => :sierra
    sha256 "71a62c7fd0ff3de0025eb622c47aa92336657c72e8dcdd7b7e8dea4c312c0555" => :el_capitan
    sha256 "5f11d171526eebc7a64ff690ff9cdc8ff9eecc46629ac992643dc02ced795f12" => :yosemite
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
