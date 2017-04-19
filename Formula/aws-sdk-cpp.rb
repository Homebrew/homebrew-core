class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.105.tar.gz"
  sha256 "e371c50b6543bb8cc23efbf23ffa8032328ecffee738c328e7f52d65cae1378b"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "197d11374682b4b176ee3dbd4beaec73c5932af4f85826ed667381ea895c5546" => :sierra
    sha256 "70133ec8383902abc98b198f5116b4b246d2b75562d14e41ffcf2adb12ec5da1" => :el_capitan
    sha256 "b9b0a63e288d9d52938fd989a05e5eb0c9dfa5c72e5db9358719abd9015195a5" => :yosemite
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
