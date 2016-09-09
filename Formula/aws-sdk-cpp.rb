class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.5.tar.gz"
  sha256 "dfc334da8b7c8d2c0c83636a432aecc7f866172c7c4d9b3df82722e7b7023eea"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "b96183a9ae83fc7149951c2fc881dfb12c1540bdb281c3de60dad288e86667dd" => :el_capitan
    sha256 "01d58d318a500677bf819bb5e9d7dc107fd099a1e37f609d05b8f0555dc9189f" => :yosemite
    sha256 "3c1f3d0417d453cb79cdbcbc1821a281aa1ed312ab0b59cf3a934bb4fde2c38b" => :mavericks
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
