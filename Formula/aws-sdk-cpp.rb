class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.131.tar.gz"
  sha256 "1cee828cce6a6bd41ddea41c86017ebbfdaadf7ce0a0af3a38fce6ec77376733"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "a3deabf6b222bf448af5b36c4dddbfde52d44b3190b4b8a3934b074212a6ffdc" => :sierra
    sha256 "b0711e867b86d6fc45a8594324cc3b6bc8188e9f2a8680b2d2bfd343f97a028d" => :el_capitan
    sha256 "bb2eb647e615106e4775b28cd7cb7297dd2d83a3094f7b7bc2542662be980c88" => :yosemite
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
