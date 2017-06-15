class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.151.tar.gz"
  sha256 "936ed045163332478d751ebd714255644971de9337a751ca3b1872d2d9b7ccf0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "09f12ee1535276208b5c52f0eaac247451076d89ba71ba59f554808464b9a1a8" => :sierra
    sha256 "b6534601902cd4cb4d3958ef44bd839fc60d807dffcc54ef5d2045f931e715b6" => :el_capitan
    sha256 "1d52470da972a9f903915bd0b2c422080b0a3bc6072beefa9c2c867af2a2e5f6" => :yosemite
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
