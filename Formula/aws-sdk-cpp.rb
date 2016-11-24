class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.34.tar.gz"
  sha256 "8e864bac594fa9519fb8638dcc538708e5ae1bf32d3e4aa3ce4655c8c60f26a8"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "91f75f03b4c566e647e0c6957a9913f0a14c700f54b6c6fedc2ee136caad3db6" => :sierra
    sha256 "6a4389e1f44974f7b7e554a5812b5a8dea7ef1949371fbac0d0423b6176ea786" => :el_capitan
    sha256 "102df0a0575b68addbc557561e5815fe3e0f6aff2dd7efd093d9d0c6d5950692" => :yosemite
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
