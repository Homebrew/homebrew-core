class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.13.7.tar.gz"
  sha256 "8764bb6fa6f40d151c9be7b554bad8cd89aa6b2f7d21cabfd0064e619ac067ce"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "392645d53b57c5b917c4dda7935508c2d6c83691d7919da1ab4eeb46832fd5cc" => :el_capitan
    sha256 "29703a17408b8768b225277ba47f579a35116f92fccdf51e2daef1c69782a021" => :yosemite
    sha256 "6fddc9ac8a0d0b31a97dc549668f3b5ab4548e3ac233b8d0b7ebd9f707fbf4e5" => :mavericks
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
