class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.12.12.tar.gz"
  sha256 "52d5885e5fc754850a05caae586b108b23d2eae08b9f1d50b68285e24ce26bdc"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "83b3f8f0ee950d9b0daad5f36cb9a81f9043dcbd54a0a2b3ca7d985a0af5e327" => :el_capitan
    sha256 "24332c0b21ec0f284611868ce4a318da10e4c910eccedc613a156ae2dafa3052" => :yosemite
    sha256 "10075203ca3ae78c806bc2cc5bf7d25096b3660f41112275f2b8e5bb4327e74e" => :mavericks
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
