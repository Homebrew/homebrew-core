class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.56.tar.gz"
  sha256 "e78d2c00e042b1f010d6cbbfc2b5f1a51ddbc32ae894e7f6ecc863ee67b730f3"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "08612096b3633c0f3ac57a44d239e1732707abe5a971c41e9b30e1778d4bd73b" => :sierra
    sha256 "d7923ac0e8267af9a3eb3a7ecdfc21caa15c9751c0fb529cd1623db4a4788d4a" => :el_capitan
    sha256 "d3ec9b935ae34e6de19354cec37ee40f53a697dff5913827a5469b378a579f9b" => :yosemite
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
