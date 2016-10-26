class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.22.tar.gz"
  sha256 "f41020b18ad845c4d16a56477add5e05af9dd3f4184fa27b79d59f8f45bf2ffb"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a7945528abdd6ceb3795d152bf344064fd9b235586812f77c5bc5bc34325b175" => :sierra
    sha256 "9ccebc0124906322d1e5d459e8602742de4dbaba6ae8acd566b087f30ce744a6" => :el_capitan
    sha256 "0e244ea3e846440fbaf76755758e7c86cc22be3266152e04005e22d2cdd8909f" => :yosemite
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
