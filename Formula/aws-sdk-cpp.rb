class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.133.tar.gz"
  sha256 "b28e2c2c2464fb2b9fd139c8e41c20d933ad8f01e47168136d56006471d2d359"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "becf7e9d94ff52432c9efad9caf31eec3726353c129a2a8cff8b7459eca1bb11" => :sierra
    sha256 "6ab186c36343a2f0a4a520a1147a8c5cb37b568b8126c031bbc9a39c9a0562d6" => :el_capitan
    sha256 "e3b4b00f70dbab636957e93b4a76963c1ce22b5519e03dcb8ba8f1ffd9fec599" => :yosemite
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
