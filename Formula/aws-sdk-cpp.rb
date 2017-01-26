class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.58.tar.gz"
  sha256 "96d6cb4dd5fbafcd1054b19a736fc585da7f59a5d020b29d497c3bef0b6ef5f3"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "7bff3a75b87e448897066c48a21011d16e0359114768b11b561db98e6b93d174" => :sierra
    sha256 "b345c5be74e715b33a7dcf334bf8b385c5fe3bac79d5748c26c3a3ce5ff687a1" => :el_capitan
    sha256 "5e067e2e6e9fef2915de429a6bb977ab7e9d62c1f3551b80d1a52d1b014f2eee" => :yosemite
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
