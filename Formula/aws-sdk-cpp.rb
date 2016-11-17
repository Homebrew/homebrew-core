class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.30.tar.gz"
  sha256 "8366a23ece1d7a23bd1e41b0698ffadbfda8618f52ee794fe2a42b91d0ed2c88"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "5996a2d12ed7ccd5b7184cbb1c6f4e9f914cc64da27f2bf121b81fcfcabf62e4" => :sierra
    sha256 "8d48dd67fab410ca2d40c9fc409241170e314361ce1e6d1458d9b7598cda7b2b" => :el_capitan
    sha256 "1184444b17b0349664afc480b39f5872ce2307b214bd3a8f0427c690b8e45e9d" => :yosemite
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
