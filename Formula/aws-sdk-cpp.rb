class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.14.6.tar.gz"
  sha256 "14fa3dbca1aea92f1cf0d53c07b9466ea6b04df8eb3ee3504af8ea35db9ea2d2"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "8510173dce9747be0eb38c1cfbd6342d0a631314d3ac25786c3f0eae52c2f4f0" => :el_capitan
    sha256 "07ef8db77c926a886a986c2e693bb1a759fe8e0ede7973d4377e715125bf7c09" => :yosemite
    sha256 "8b9ac70a515286e3a857c48addd12722d89a99dfca7af7e63fb9fe52bd3dd1cc" => :mavericks
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
