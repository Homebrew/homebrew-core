class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.12.17.tar.gz"
  sha256 "ac74035ddf14783a5599b36885db1c7000e01bf92534e9b75ac4957daeca8b6f"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "39d2bc341de3f1c9c699d888aa8a5b7386ffcce20d758abeed148031bdbe9b9f" => :el_capitan
    sha256 "8fba2c2d4af13f0d7651e55f65ffd04abf4e15b19b16a87b6eee3233ec6a5b30" => :yosemite
    sha256 "28bfd82f888c2c40ceade873be6ddec31a54f110c73bb74c00ecc43440606ac9" => :mavericks
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
