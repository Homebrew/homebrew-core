class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.54.tar.gz"
  sha256 "c7c550d27745ba2d7b5e308c2746dab21fb19ab40a1e4b2de459b460f8cd1dab"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "f559ba1948a8c6fe1d093fe4adcda32bcce0994e7ecf7f232bf93a802a3efaec" => :sierra
    sha256 "090252ea30b8290062b87829fd2612d9d290b65884fdf1d918a2c55c06b92034" => :el_capitan
    sha256 "7a45a7f7bc7a60f4723cca6a8c1edc7b7e72c509c2629a3cd10b8ed22fd62655" => :yosemite
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
