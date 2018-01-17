class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.3.40.tar.gz"
  sha256 "4635e4f31608e75179fbf7a59e57a78d5370f6323d4822115871730b09ae9081"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "21d0c5f2fcd3b1367db5edb7dc536ef919d5c4c5ba8d61f1aeb277c815f7880c" => :high_sierra
    sha256 "8303bc3398be36e6684df64b3a514d3675715c59b4ce408453b6cee66852072d" => :sierra
    sha256 "a435257c11cd8e7a172c4a017154ab97df058d5f859959e5e280138d2e663eb5" => :el_capitan
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
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-laws-cpp-sdk-core"
    system "./test"
  end
end
