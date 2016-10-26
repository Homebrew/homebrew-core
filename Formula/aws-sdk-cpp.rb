class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.22.tar.gz"
  sha256 "f41020b18ad845c4d16a56477add5e05af9dd3f4184fa27b79d59f8f45bf2ffb"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "743d7658f7270e5be19c3cf5d1ddf3089ad50b93ec96517edfed2abacc0ccd4f" => :sierra
    sha256 "073ff5342f6a58ff1c3e2e4904a63334988ed7f4df5cdae2ec72b75f8e66a0b8" => :el_capitan
    sha256 "b369b7658fc1cd9de090ef5fa8f87d4049953c69d2b8348ac3239565f0e0802d" => :yosemite
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
