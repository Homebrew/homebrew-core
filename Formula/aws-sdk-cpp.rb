class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.60.tar.gz"
  sha256 "64ccb2c02871d10169e4b82ce2839995d14213fcf9910eb2bbd424daf5ee6f1d"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "e2cd5d3ddbabee3066a9d2dcf8129923710eee7806399a343c027809b49861ea" => :sierra
    sha256 "6ef6b00af2ed68f36c61b13f7e2dfff9d3694e0c10f3ccd83db392410388402c" => :el_capitan
    sha256 "039e6c0fc9c3b68a3db876f8c32ef8d47a019a2082d4f2a9225a6e52cfec69bd" => :yosemite
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
