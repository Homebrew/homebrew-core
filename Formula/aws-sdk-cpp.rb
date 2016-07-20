class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.13.7.tar.gz"
  sha256 "8764bb6fa6f40d151c9be7b554bad8cd89aa6b2f7d21cabfd0064e619ac067ce"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "cc78e1d51e7f1af6bef9821794502fb778f7911cdef5f60f188b5441273e6ff6" => :el_capitan
    sha256 "9f64a1684f6ee7a2ba4d3d19a3d8f0d7fc156d564b2441e24666fafc3a7cc271" => :yosemite
    sha256 "4eaaf2b8b0f179f25996e3c33f159211889522e393aa678f19646608210e0d2d" => :mavericks
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
