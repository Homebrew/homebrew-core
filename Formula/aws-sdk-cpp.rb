class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.12.17.tar.gz"
  sha256 "ac74035ddf14783a5599b36885db1c7000e01bf92534e9b75ac4957daeca8b6f"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "c4237d91cbac6ec7e5884132b139a1587f57ab7785c6b12a09c8ce8e2bf0a9c5" => :el_capitan
    sha256 "1bbf928ba099fbc0ea9555b2e50fa47b45b7d949f5c5c91a227d58803a39b10d" => :yosemite
    sha256 "6f776a25a9a0e966c57ccb6a89c349e8dfe7e7a3613a7b572f24c07531c8be29" => :mavericks
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
