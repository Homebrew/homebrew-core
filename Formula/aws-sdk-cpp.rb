class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.13.8.tar.gz"
  sha256 "ea3e618980f41dedfc2a6b187846a2bd747d9b6d9b95f733e04bec76cbeb1a46"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "ff051159c9517e18147c0bb639e6681c382ae5039e57ca9e917ea6f4f2d0581f" => :el_capitan
    sha256 "518021184583860330afec18bd88f5f8fb70e2ad5a3e1ac8a8d6e458167c60cd" => :yosemite
    sha256 "11c9d9030a4e18069022dc60f50a530d3602b4beb30d6233b320b1b4b8b89326" => :mavericks
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
